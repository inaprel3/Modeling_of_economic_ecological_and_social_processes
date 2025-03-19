% Очищення робочого простору
clc; clear; close all;

% Задані параметри
omega1 = 100;   % Ціна на пшеницю
omega2 = 150;   % Ціна на ячмінь
FC = 300000;    % Постійні витрати

% Вектор цін на продукцію (від 500 до 1500, крок 500)
p_values = 500:500:1500;

% Ініціалізація масивів для збереження результатів
q_values = zeros(size(p_values));
q_values_barley = zeros(size(p_values));
x1_values = zeros(size(p_values));
x2_values = zeros(size(p_values));
C_values = zeros(size(p_values));
C_values_barley = zeros(size(p_values));
Cz_values = zeros(size(p_values));
Cz_values_barley = zeros(size(p_values));
AC_values = zeros(size(p_values));
AC_values_barley = zeros(size(p_values));
profit_values = zeros(size(p_values));
profit_values_barley = zeros(size(p_values));

% Обчислення всіх необхідних параметрів для кожного значення p
for i = 1:length(p_values)
    p = p_values(i);

    % Функція пропозиції продукції
    q_star = (2/sqrt(3)) * (p^2) * (omega1^(-3/2)) * (omega2^(-1/2));
    q_star_barley = (2/sqrt(3)) * (p^2) * (omega2^(-3/2)) * (omega1^(-1/2));

    % Функції попиту на ресурси
    x1_star = (1/sqrt(3)) * (p^3) * (omega1^(-5/2)) * (omega2^(-1/2));
    x2_star = (1/(3*sqrt(3))) * (p^3) * (omega1^(-3/2)) * (omega2^(-3/2));

    % Змінні витрати
    C_var = (2/3) * p * q_star;
    C_var_barley = (2/3) * p * q_star_barley;  % Для ячменю

    % Загальні витрати
    C_total = C_var + FC;
    C_total_barley = C_var_barley + FC;

    % Середні витрати
    AC = C_total / q_star;
    AC_barley = C_total_barley / q_star_barley;

    % Прибуток
    profit = (1/3) * p * q_star - FC;
    profit_barley = (1/3) * p * q_star_barley - FC;

    % Збереження значень у масиви
    q_values(i) = q_star;
    q_values_barley(i) = q_star_barley;
    x1_values(i) = x1_star;
    x2_values(i) = x2_star;
    C_values(i) = C_var;
    C_values_barley(i) = C_var_barley;
    Cz_values(i) = C_total;
    Cz_values_barley(i) = C_total_barley;
    AC_values(i) = AC;
    AC_values_barley(i) = AC_barley;
    profit_values(i) = profit;
    profit_values_barley(i) = profit_barley;
end

% Побудова графіків
figure;

% Функція пропозиції продукції
subplot(2,3,1);
plot(p_values, q_values, '-o', 'LineWidth', 2, 'Color', 'b');
hold on;
plot(p_values, q_values_barley, '-s', 'LineWidth', 2, 'Color', 'r');
xlabel('Ціна продукції p (грн)');
ylabel('Обсяг продукції q*');
legend('Пшениця', 'Ячмінь');
title('Функція пропозиції продукції');
grid on;

% Функція попиту на ресурси
subplot(2,3,2);
plot(p_values, x1_values, '-o', 'LineWidth', 2, 'Color', 'b');
hold on;
plot(p_values, x2_values, '-s', 'LineWidth', 2, 'Color', 'r');
xlabel('Ціна продукції p (грн)');
ylabel('Попит на ресурси x1*, x2*');
legend('x1* (пшениця)', 'x2* (ячмінь)');
title('Функція попиту на ресурси');
grid on;

% Змінні витрати
subplot(2,3,3);
plot(p_values, C_values, '-o', 'LineWidth', 2, 'Color', 'b');
hold on;
plot(p_values, C_values_barley, '-s', 'LineWidth', 2, 'Color', 'r');
xlabel('Ціна продукції p (грн)');
ylabel('Змінні витрати C(q)');
legend('Пшениця', 'Ячмінь');
title('Змінні витрати фірми');
grid on;

% Загальні витрати
subplot(2,3,4);
plot(p_values, Cz_values, '-o', 'LineWidth', 2, 'Color', 'b');
hold on;
plot(p_values, Cz_values_barley, '-s', 'LineWidth', 2, 'Color', 'r');
xlabel('Ціна продукції p (грн)');
ylabel('Загальні витрати C_з(q)');
legend('Пшениця', 'Ячмінь');
title('Загальні витрати фірми');
grid on;

% Середні витрати
subplot(2,3,5);
plot(p_values, AC_values, '-o', 'LineWidth', 2, 'Color', 'b');
hold on;
plot(p_values, AC_values_barley, '-s', 'LineWidth', 2, 'Color', 'r');
xlabel('Ціна продукції p (грн)');
ylabel('Середні витрати AC(q)');
legend('Пшениця', 'Ячмінь');
title('Середні витрати фірми');
grid on;

% Область прибутковості
subplot(2,3,6);
plot(p_values, profit_values, '-o', 'LineWidth', 2, 'Color', 'b');
hold on;
plot(p_values, profit_values_barley, '-s', 'LineWidth', 2, 'Color', 'r');
yline(0, '--k', 'Лінія беззбитковості');
xlabel('Ціна продукції p (грн)');
ylabel('Прибуток фірми');
legend('Пшениця', 'Ячмінь');
title('Область прибутковості');
grid on;

% Вивід у консоль
disp('Таблиця результатів:');
disp(table(p_values', q_values', q_values_barley', x1_values', x2_values', C_values', C_values_barley', ...
    Cz_values', Cz_values_barley', AC_values', AC_values_barley', profit_values', profit_values_barley', ...
    'VariableNames', {'p', 'q_star_wheat', 'q_star_barley', 'x1_star', 'x2_star', 'C_var_wheat', 'C_var_barley', ...
    'C_total_wheat', 'C_total_barley', 'AC_wheat', 'AC_barley', 'Profit_wheat', 'Profit_barley'}));
