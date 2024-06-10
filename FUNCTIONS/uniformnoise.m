function [noise_img, noise] = uniformnoise(img, degree)
    % Check if the image is in the range [0, 1]
    if max(img(:)) > 1
        img = double(img) / 255; % Convert to double and scale if necessary
    end

    % Uniform noise parameters influenced by degree
    a = 0;
    b = a + 0.5 * degree;  % scale maximum noise by degree

    % Get image dimensions
    [x, y] = size(img);

    % Generate uniform noise
    noise = a + (b-a) .* rand(x, y);

    % Add noise to the image
    noise_img = img + noise;
    noise_img = max(0, min(noise_img, 1)); % Clip values to stay within [0, 1]
end
