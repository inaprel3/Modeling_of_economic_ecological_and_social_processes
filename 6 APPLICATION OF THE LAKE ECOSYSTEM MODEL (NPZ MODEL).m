% lab6_npz_model.m

function lab6_npz_model
    clc; clear; close all;

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

    figure('Name', 'Вплив параметра e на NPZ-модель', 'NumberTitle', 'off');
    for i = 1:length(e_values)
        e = e_values(i);
        [t, Y] = ode45(@(t, y) npz_system(y, a, b, e, r, m), tspan, y0);

        subplot(3,1,1);
        plot(t, Y(:,1), 'Color', colors(i), 'LineWidth', 1.5); hold on;
        ylabel('N(t)');
        title('Поживні речовини N(t)');
        grid on;

        subplot(3,1,2);
        plot(t, Y(:,2), 'Color', colors(i), 'LineWidth', 1.5); hold on;
        ylabel('P(t)');
        title('Фітопланктон P(t)');
        grid on;

        subplot(3,1,3);
        plot(t, Y(:,3), 'Color', colors(i), 'LineWidth', 1.5); hold on;
        ylabel('Z(t)');
        xlabel('Час t');
        title('Зоопланктон Z(t)');
        grid on;
    end

    legend_str = arrayfun(@(e) sprintf('e = %.1f', e), e_values, 'UniformOutput', false);
    subplot(3,1,1); legend(legend_str);
    subplot(3,1,2); legend(legend_str);
    subplot(3,1,3); legend(legend_str);
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
