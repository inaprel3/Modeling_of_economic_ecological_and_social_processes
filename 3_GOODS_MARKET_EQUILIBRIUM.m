% Початкові коефіцієнти функцій попиту та пропозиції
a_d = 800; b_d = -16; % Q_d = a_d + b_d * P
a_s = 120; b_s = 8;   % Q_s = a_s + b_s * P

% Знаходження рівноважної ціни та обсягу продажу
P_eq = (a_d - a_s) / (b_s - b_d);
Q_eq = a_d + b_d * P_eq;

% Обчислення цінової еластичності
E_d = (b_d * P_eq) / Q_eq;
E_s = (b_s * P_eq) / Q_eq;

% Вивід результатів
fprintf('Рівноважна ціна: P* = %.2f\n', P_eq);
fprintf('Рівноважний обсяг продажу: Q* = %.2f\n', Q_eq);
fprintf('Цінова еластичність попиту: E_d = %.2f\n', E_d);
fprintf('Цінова еластичність пропозиції: E_s = %.2f\n', E_s);

% Нові коефіцієнти (подвоєння при P)
b_d_new = b_d * 2;
b_s_new = b_s * 2;

% Нові рівноважні значення
P_eq_new = (a_d - a_s) / (b_s_new - b_d_new);
Q_eq_new = a_d + b_d_new * P_eq_new;

% Нові цінові еластичності
E_d_new = (b_d_new * P_eq_new) / Q_eq_new;
E_s_new = (b_s_new * P_eq_new) / Q_eq_new;

% Вивід нових результатів
fprintf('Нова рівноважна ціна: P* = %.2f\n', P_eq_new);
fprintf('Новий рівноважний обсяг продажу: Q* = %.2f\n', Q_eq_new);
fprintf('Нова цінова еластичність попиту: E_d = %.2f\n', E_d_new);
fprintf('Нова цінова еластичність пропозиції: E_s = %.2f\n', E_s_new);

% Побудова графіків
P_vals = linspace(0, 100, 100);
Qd_vals = a_d + b_d * P_vals;
Qs_vals = a_s + b_s * P_vals;
Qd_new_vals = a_d + b_d_new * P_vals;
Qs_new_vals = a_s + b_s_new * P_vals;

figure;
hold on;
plot(P_vals, Qd_vals, 'r', 'LineWidth', 2);
plot(P_vals, Qs_vals, 'b', 'LineWidth', 2);
plot(P_eq, Q_eq, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
plot(P_vals, Qd_new_vals, 'r--', 'LineWidth', 2);
plot(P_vals, Qs_new_vals, 'b--', 'LineWidth', 2);
plot(P_eq_new, Q_eq_new, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

xlabel('Ціна (P)');
ylabel('Обсяг (Q)');
title('Ринок гречки в Україні');
legend('Попит (Q_d)', 'Пропозиція (Q_s)', 'Стара рівновага', ...
       'Новий попит (Q_d new)', 'Нова пропозиція (Q_s new)', 'Нова рівновага', ...
       'Location', 'Best');
grid on;
hold off;
