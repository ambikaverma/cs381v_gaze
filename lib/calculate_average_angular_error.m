% Used for testing accuracy.
%
% Args:
%   heads1 - (nx2) the prediction heads
%   gazes1 - (nx2) the prediction gazes
%   heads2 - (nx2) the prediction heads
%   gazes2 - (nx2) the prediction gazes
% Returns:
%   result (float) angular error between the two

function result = calculate_average_angular_error (heads1, gazes1, heads2, gazes2)
    n = size(heads1, 1);
    result = 0;
    for i = 1:n
        result = result + calculate_angular_error(heads1(i, :), gazes1(i, :), ...
                                                  heads2(i, :), gazes2(i, :));
    end
    result = result / n;
end
