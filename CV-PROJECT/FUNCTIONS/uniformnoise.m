function [noise_img, noise] = uniformnoise(JJ, degree)
    % Uniform noise parameters influenced by degree
    a = 0;
    b = a + 0.5 * degree;  % scale maximum noise by degree

    % Get image dimensions
    [x, y] = size(JJ);

    % Generate uniform noise
    noise = a + (b-a) .* rand(x, y);

    % Add noise to the image
    noise_img = JJ + noise;
    noise_img = max(0, min(noise_img, 1)); % Clip values to stay within [0, 1]
end



