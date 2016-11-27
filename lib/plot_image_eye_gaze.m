% Helper method to plot.
%
% Args:
%   im - (mxn) image to plot
%   eyes - (nx2) x,y pairs of eyes
%   gazes - (nx2) x,y pairs of gazes
%   color - (str) color of dot and line.

function plot_image_eye_gaze(im, eyes, gazes, color)
    [height, width, ~] = size(im);

    % Transform normalized coordinates back.
    real_eyes_x = width * eyes(:, 1);
    real_eyes_y = height * eyes(:, 2);

    % Transform normalized coordinates back.
    real_gaze_vector_x = width * (gazes(:, 1) - eyes(:, 1));
    real_gaze_vector_y = height * (gazes(:, 2) - eyes(:, 2));

    % Plot the stuff.
    plot(real_eyes_x, real_eyes_y, strcat(color, '.'), 'MarkerSize', 10);
    quiver(real_eyes_x, real_eyes_y, ...
           real_gaze_vector_x, real_gaze_vector_y, 0, ...
           'LineWidth', 2, 'Color', color);
end
