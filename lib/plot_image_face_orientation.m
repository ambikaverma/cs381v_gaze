% Helper method to plot.
%
% Args:
%   im - (mxn) image to plot
%   faces - (nx2) x,y pairs of eyes
%   orientations - (nx2) x,y pairs of gazes
% Returns:
%   void

function plot_image_face_orientation(im, faces, orientations)
    [height, width, ~] = size(im);

    % Make the norms a bit better to see.
    for i = 1:size(orientations, 1)
        orientations(i, :) = orientations(i, :) * 25;
    end

    % Transform normalized coordinates back.
    real_faces_x = width * faces(:, 1);
    real_faces_y = height * faces(:, 2);

    % Plot the stuff.
    plot(real_faces_x, real_faces_y, 'b.', 'MarkerSize', 20);
    quiver(real_faces_x, real_faces_y, ...
           orientations(:, 1), orientations(:, 2), ...
           0, 'LineWidth', 2, 'Color', 'b');
end
