% lab6_npz_model.m
function lab6_npz_model
    clc; close all;

    %% === Модельна задача ===
    a = 1.0;
    b = 0.5;
    e = 0.3;
    r = 0.2;
    m = 0.1;

    N0 = 2.0; P0 = 1.0; Z0 = 0.5;
    y0 = [N0, P0, Z0];
    tspan = 0:0.1:100;

    [t, Y] = ode45(@(t, y) npz_system(y, a, b, e, r, m), tspan, y0);

    figure('Name', 'Модельна задача NPZ', 'NumberTitle', 'off');
    plot(t, Y(:,1), 'b-', 'LineWidth', 2); hold on;
    plot(t, Y(:,2), 'g-', 'LineWidth', 2);
    plot(t, Y(:,3), 'r-', 'LineWidth', 2);
    xlabel('Час t'); ylabel('Чисельність компонентів');
    legend('Поживні речовини N', 'Фітопланктон P', 'Зоопланктон Z');
    title('Модельна задача: NPZ-модель екосистеми');
    grid on;

    %% === Основне завдання: варіація e ===
    e_values = 0.1:0.1:0.5;
    colors = ['b', 'g', 'r', 'm', 'k'];
    legend_str = arrayfun(@(e) sprintf('e = %.1f', e), e_values, 'UniformOutput', false);

        % === Окремий графік для N(t) ===
    figure('Name', 'N(t) при різних e', 'NumberTitle', 'off', 'Position', [100, 100, 800, 400]);
    for i = 1:length(e_values)
        e = e_values(i);
        [t_full, Y_full] = ode45(@(t, y) npz_system(y, a, b, e, r, m), tspan, y0);
        idx = t_full >= 3 & t_full <= 70;  % обмеження по часу
        plot(t_full(idx), Y_full(idx,1), 'Color', colors(i), 'LineWidth', 1.5); hold on;
    end
    xlim([3 70]);
    xlabel('Час t'); ylabel('N(t)');
    title('Поживні речовини N(t)');
    legend(legend_str);
    grid on;

        % === Окремий графік для P(t) ===
    figure('Name', 'P(t) при різних e', 'NumberTitle', 'off', 'Position', [250, 150, 800, 400]);
    for i = 1:length(e_values)
        e = e_values(i);
        [t_full, Y_full] = ode45(@(t, y) npz_system(y, a, b, e, r, m), tspan, y0);
        idx = t_full >= 5 & t_full <= 35;  % обмеження по часу
        plot(t_full(idx), Y_full(idx,2), 'Color', colors(i), 'LineWidth', 1.5); hold on;
    end
    xlim([5 35]);
    xlabel('Час t'); ylabel('P(t)');
    title('Фітопланктон P(t)');
    legend(legend_str);
    grid on;

     % === Окремий графік для Z(t) ===
    figure('Name', 'Z(t) при різних e', 'NumberTitle', 'off', 'Position', [300, 100, 800, 400]);
    for i = 1:length(e_values)
        e = e_values(i);
        [t_full, Y_full] = ode45(@(t, y) npz_system(y, a, b, e, r, m), tspan, y0);
        idx = t_full <= 50;  % тільки до часу 50
        plot(t_full(idx), Y_full(idx,3), 'Color', colors(i), 'LineWidth', 1.5); hold on;
    end
    xlim([0 50]);
    xlabel('Час t'); ylabel('Z(t)');
    title('Зоопланктон Z(t)');
    legend(legend_str);
    grid on;
end

%% === Підфункція NPZ-моделі ===
function dydt = npz_system(y, a, b, e, r, m)
    N = y(1);
    P = y(2);
    Z = y(3);

    dNdt = -a*N*P + r*P + m*Z;
    dPdt = a*N*P - b*P - r*P;
    dZdt = e*b*P*Z - m*Z;

    dydt = [dNdt; dPdt; dZdt];
end
