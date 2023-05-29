% EL
% Feb 2023

% Figure of P/D vs T and P/D vs FeRatio
% geotherm data as given by Miyazaki & Korenaga 2020 
% r_eq values calculated from FeRatioH22.m
% Uses data in geotherms.xlsx and geotherms_combo.xlsx


clear;

data2500K = readmatrix('\db\geotherms.xlsx', 'Sheet', '2500K');
P = data2500K(:,2);
z = data2500K(:,3);
T_2500K = data2500K(:,4);
r_eq2500K = data2500K(:,7);

data3000K = readmatrix('\db\geotherms.xlsx', 'Sheet', '3000K');
T_3000K = data3000K(:,4);
r_eq3000K = data3000K(:,7);

data3500K = readmatrix('\db\geotherms.xlsx', 'Sheet', '3500K');
T_3500K = data3500K(:,4);
r_eq3500K = data3500K(:,7);

data4000K = readmatrix('\db\geotherms.xlsx', 'Sheet', '4000K');
T_4000K = data4000K(:,4);
r_eq4000K = data4000K(:,7);

data4500K = readmatrix('\db\geotherms.xlsx', 'Sheet', '4500K');
T_4500K = data4500K(:,4);
r_eq4500K = data4500K(:,7);

data_adiab = readmatrix('\db\geotherms_combo.xlsx', 'Sheet', 'Sheet1');
Tsol = data_adiab(:,3);
Tliq = data_adiab(:,4);
Tphi = data_adiab(:,5);

[val, cutoff_2500K] = min(abs(Tphi-T_2500K));

% to get correct scale for depth axis
z_test = [0 500 1000 1500 2000 2500 2800];
P_test = zeros(1, length(z_test));
T_test = zeros(1, length(z_test));
r_test = zeros(1, length(z_test));
for i = 1:length(z_test)
    [~,idx] = min(abs(z - z_test(i)));
    P_test(i) = P(idx);
    T_test(i) = Tphi(idx);
    r_test(i) = r_eq4500K(i);
end

%range for post-Cr oxidation = modern day mantle FeO*
r_low_f = 0.02;
r_high_f = 0.06;

%range for pre-Cr oxidation with 8.05% FeO* from Deng20 composition
r_low_0 = r_low_f + 0.35/8.05;
r_high_0 = r_high_f + 0.35/8.05;
    
figure('Position', [30 30 800 500]);
subplot(1,2,1)
hold on
box on
yyaxis left
colororder('default')
p1 = plot(T_2500K, P, "LineWidth", 1.5);
p2 = plot(T_3000K, P, "LineWidth", 1.5);
p3 = plot(T_3500K, P, "LineWidth", 1.5);
p4 = plot(T_4000K, P, "LineWidth", 1.5);
p5 = plot(T_4500K, P, "LineWidth", 1.5);
p6 = plot(Tsol, P, 'k--');
p7 = plot(Tliq, P, 'k-');
p8 = plot(Tphi, P, 'k:');
ylabel('Pressure (GPa)')
xlabel('Temperature (K)')
ylim([0 135.14])
yticks([0, 20, 40, 60, 80, 100, 120, 135])
yticklabels(["0","20","40","60","80","100","120","135"])
ax = gca;
ax.YDir = 'reverse';
ax.YColor = [0.15 0.15 0.15];

yyaxis right
plot(T_test, P_test, 'k.', 'MarkerSize', 0.1)
%ylabel("Depth (km)")
ylim([0 135.14])
yticks(P_test)
%yticklabels(z_test)
yticklabels(["", "", "", "", "", "", ""])
ax = gca;
ax.YDir = 'reverse';
ax.YColor = [0.15 0.15 0.15];

text(5500, 5, 'a', 'FontSize', 20, 'FontWeight', 'bold')
legend([p1 p2 p3 p4 p5 p6 p7 p8], "2500 K", "3000 K", "3500 K", "4000 K", "4500 K", "solidus", "liquidus", "\phi = 0.4", 'Location', 'southwest')

subplot(1,2,2)
hold on
box on
yyaxis left
colororder('default')
x = [r_low_f r_high_f];       %shaded region
y = [135 135];
area(x,y, 'FaceColor', [0.87 0.87 0.87])
x_0 = [r_low_0 r_high_0];
area(x_0,y, 'FaceColor', [0.75 0.75 0.75])
r1 = plot(r_eq2500K(1:cutoff_2500K), P(1:cutoff_2500K), 'Color', "#0072BD", "LineWidth", 1.5);
r2 = plot(r_eq3000K, P, "Color", "#D95319", "LineWidth", 1.5);
r3 = plot(r_eq3500K, P, "Color", "#EDB120", "LineWidth", 1.5);
r4 = plot(r_eq4000K, P, "Color", "#7E2F8E", "LineWidth", 1.5);
r5 = plot(r_eq4500K, P, "Color", "#77AC30", "LineWidth", 1.5);
xlabel('Fe^{3+}/\SigmaFe Ratio')
%ylabel('Pressure (GPa)')

xticks([0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3])
ylim([0 135])
yticks([0, 20, 40, 60, 80, 100, 120, 135])
% yticklabels(["0","20","40","60","80","100","120","135"])
yticklabels(["","","","","","","",""])
ax = gca;
ax.YDir = 'reverse';
ax.YColor = [0.15 0.15 0.15];
ax.Layer = 'top';

yyaxis right
plot(r_test, P_test, 'k.', 'MarkerSize', 0.1)
ylabel("Depth (km)")
ylim([0 135.14])
yticks(P_test)
yticklabels(z_test)
ax = gca;
ax.YDir = 'reverse';
ax.YColor = [0.15 0.15 0.15];

text(0.27, 5, 'b', 'FontSize', 20, 'FontWeight', 'bold')

hold off

