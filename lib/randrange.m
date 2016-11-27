% Returns a float in the range [a, b].
%
% Args:
%   a - (float) min value.
%   b - (float) max value.
% Returns:
%   result (float), the random value.

function result = randrange(a, b)
    % Uniform distribution.
    SAMPLES = 10;

    % Chunk size.
    step = (b - a) / SAMPLES;

    % Inclusive of [a, b];
    possible_values = ([0:SAMPLES]).*step + a;

    % Pick a random index in the range.
    result = possible_values(randi(size(possible_values, 2)));
end
