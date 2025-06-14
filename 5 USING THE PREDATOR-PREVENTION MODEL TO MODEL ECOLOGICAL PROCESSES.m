% lab5_predator_prey.m

function lab5_predator_prey
    % Лабораторна робота №5: Модель "Хижак–Жертва" (Лотка–Вольтерра)
    clc; clear; close all;

    %% === Частина 1: Модельна задача ===
    alpha = 1.0;
    beta = 0.1;
    gamma = 0.4;
    delta = 0.02;

    x0 = 40; y0 = 9;
    y_init = [x0, y0];
    tspan = 0:10:200;

    [t, Y] = ode45(@(t,y) lotka_volterra(y, alpha, beta, gamma, delta), tspan, y_init);

    figure('Name','Модельна задача','NumberTitle','off');
    plot(t, Y(:,1), 'g-', 'LineWidth', 2); hold on;
    plot(t, Y(:,2), 'r-', 'LineWidth', 2);
    xlabel('Час t'); ylabel('Чисельність популяцій');
    legend('Жертви (x)', 'Хижаки (y)');
    title('Модельна задача: \alpha=1.0, \beta=0.1, \gamma=0.4, \delta=0.02');
    grid on;

    %% === Частина 2: Основне завдання (без фазового портрета) ===
    alpha = 0.9;
    gamma = 0.5;
    delta = 0.02;
    x0 = 50; y0 = 10;
    y_init = [x0, y0];
    tspan = 0:10:200;

    beta_values = [0.01, 0.05, 0.1, 0.2];

    figure('Name','Динаміка популяцій при різних \beta','NumberTitle','off');

    for i = 1:length(beta_values)
        beta = beta_values(i);
        [t, Y] = ode45(@(t,y) lotka_volterra(y, alpha, beta, gamma, delta), tspan, y_init);

        subplot(2,2,i);
        plot(t, Y(:,1), 'Color', [1 0.5 0], 'LineWidth', 1.8); hold on; % оранжевий — жертви
        plot(t, Y(:,2), 'Color', [0 0.6 1], 'LineWidth', 1.8);           % блакитний — хижаки
        xlabel('Час');
        ylabel('Чисельність');
        title(['\beta = ' num2str(beta)]);
        legend('Жертви', 'Хижаки');
        grid on;
    end
end

%% === Підфункція моделі Лотки–Вольтерра ===
function dydt = lotka_volterra(y, alpha, beta, gamma, delta)
    x = y(1);
    y_ = y(2);
    dxdt = alpha * x - beta * x * y_;
    dydt_ = delta * x * y_ - gamma * y_;
    dydt = [dxdt; dydt_];
end
