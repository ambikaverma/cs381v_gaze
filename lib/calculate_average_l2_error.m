% Used for testing accuracy.
%
% Args:
%   predictions - (nx2) the prediction gazes.
%   gazes - (nx2) the ground truth gazes.
% Returns:
%   result (float) angular error between the two

function result = calculate_average_l2_error(predictions, gazes)
    n = size(predictions, 1);
    result = 0;
    for i = 1:n
        result = result + calculate_distance(predictions(i, :), gazes(i, :));
    end
    result = result / n;
end
