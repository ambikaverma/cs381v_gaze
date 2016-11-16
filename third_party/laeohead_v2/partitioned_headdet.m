function partitioned_headdet(img_path)
  addpath('/Users/bradyzhou/code/cs381v_final/voc-release5');

  % Load the head detector
  load('head-gen-on-ub-4laeo.mat'); % IJCV'2013
  lsymbs = '><><><';
  detthr = -0.97;

  % Load image
  img = imread(img_path);

  %% Run head detector on the whole image: it works better on upper-body areas.
  [dets, boxes] = imgdetect(img, model, detthr);

  dets

  % Keep only the best ones after NMS
  top = nms(dets, 0.5);
  dets = dets(top,:);

  %% Draw the detections
  bbox = [];
  if size(dets, 1) > 0
      bbox = dets(:,[1:4 end-1 end]);
  end

  cla reset;
  imshow(img), hold on;
  axis on;
  for ii = 1:size(bbox,1)
     hr = rectangle('Position', [bbox(ii,1) bbox(ii,2) bbox(ii,3)-bbox(ii,1) bbox(ii,4)-bbox(ii,2)]);
     set(hr, 'EdgeColor', [1 0 0]);
     set(hr, 'LineWidth', 3);

     % % Add direction label
     % component = bbox(ii, end-1);
     % str = lsymbs(component);
     % ht = text(bbox(ii,1)+10, bbox(ii,2)+20 , str);
     % set(ht, 'FontSize', 14);
     % set(ht, 'Color', [0 0 1]);
     % set(ht, 'BackgroundColor', [1 1 1]);
     % set(ht, 'FontWeight', 'bold');

     % Add score
     str = sprintf('%.2f', bbox(ii, end));
     ht = text(bbox(ii,1)+8, bbox(ii,4)-15 , str);
     set(ht, 'FontSize', 10);
     set(ht, 'Color', [0 0.8 1]);
     %set(ht, 'BackgroundColor', [1 1 1]);
     set(ht, 'FontWeight', 'bold');
  end

  axis equal;
  axis off;
  drawnow;

  print -dpng 'detections.png';
end
