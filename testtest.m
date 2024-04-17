% clear
% clc
% tic

function testtest(folder_path)
%folder_path = uigetdir;
if nargin < 1 || isempty(folder_path)
        folder_path = uigetdir;
end

% List all the files in the selected folder
matFiles = dir(fullfile(folder_path, '**/*.mat'));

% Bring all variables from the subfolders
for i = 1:numel(matFiles)
    mData = load(fullfile(matFiles(i).folder, matFiles(i).name));
    
    fields = fieldnames(mData);
    for j = 1:numel(fields)
        if ~isstruct(mData.(fields{j}))
            eval([fields{j}, ' = mData.(fields{j});']);
        else
            struct_variable = mData.(fields{j});
            for k = 1:numel(struct_variable)
                eval([fields{j}, '_', num2str(k), ' = struct_variable(k);']); 
            end
        end
    end
end

radiometry_path = fullfile(folder_path, 'Trios', 'radiometry.mat');

if exist(radiometry_path, 'file') == 2
    radiometry = load(radiometry_path);
    trios_ramses = radiometry.trios_ramses;
end

stationN = lisstvsfStationInfo_1.filename;
figure('Position', [0, 0, 1920, 1080])

nRows = 4;
nCols = 3;

subplot('Position', [0.042    0.725    0.285    0.2]);
hold on;
num_wL = size(at, 2);
start_wL = 400;
end_wL = 700;
wavelengths = linspace(start_wL, end_wL, num_wL);
for i = 1:size(at, 1)
    plot(wavelengths, at(i, :), 'LineWidth', 2, 'Color', [0 0 0]);
end
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 16);
xlabel('Wavelength (nm)');
ylabel('$a (m^{-1})$','Interpreter','latex', 'FontName','Times');
%title('Absorption a_{t}');
grid on;
box on;

subplot('Position', [0.385    0.725    0.285    0.2]);
hold on;
for i = 1:size(ct, 1)
    plot(wavelengths, ct(i, :), 'LineWidth', 2, 'Color', [0 0 0]);
end
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 16);
xlabel('Wavelength (nm)');
ylabel('$c_{t}(m^{-1})$','Interpreter','latex');
%title('Attenuation c_{t}');
grid on;
box on;

subplot('Position', [0.042    0.395    0.285    0.2]);
hold on;
yyaxis left
plot(ctdSampleRunJD, ctdSample(:,2))
set(gca, 'FontName', 'Times', 'FontSize', 12);
xlabel('Time (JD)')
ylabel('$Temperature (C)$', 'Interpreter','latex')
%title('Temperature and Salinity over Time')
ax = gca;
ax.XAxis.Exponent = 0;

yyaxis right
plot(ctdSampleRunJD, ctdSample(:,1))
ylabel('$Salinity$','Interpreter','latex', 'FontName','Times')
grid on;
hold off;

subplot('Position', [0.385    0.395    0.285    0.2]);
hold on;
wavelength = linspace(400, 700, 255);
colors = {'#FFE7AA', '#7D151A', '#313A75', '#378B2E'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
        plot(wavelength, trios_ramses.profiling(depth).Lwp(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
set(gca, 'FontName', 'Times', 'FontSize', 16);
box on;
grid on;
%title('L_{wp} Radiance')
xlabel('Wavelength (nm)')
ylabel('$L_{wp}$', 'Interpreter','latex')

subplot('Position', [0.042    0.072   0.285    0.2]);
hold on;
hold on;
colors = {'#88CCEE', '#CC6677', '#DDCC77', '#117733'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
    plot(wavelength, trios_ramses.profiling(depth).Edp(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
set(gca, 'FontName', 'Times', 'FontSize', 16);
box on;
grid on;
%title('E_{dp} Irradiance')
xlabel('Wavelength (nm)')
ylabel('$E_{dp}$', 'Interpreter','latex')
hold off;

subplot('Position', [0.385    0.072   0.285    0.2]);
hold on;
hold on;
colors = {'#88CCEE', '#CC6677', '#DDCC77', '#117733'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
    plot(wavelength, trios_ramses.profiling(depth).Eop(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
set(gca, 'FontName', 'Times', 'FontSize', 16);
box on;
grid on;
%title('E_{op} Radiance')
xlabel('Wavelength (nm)')
ylabel('$E_{op}$', 'Interpreter','latex')
hold off;

subplot('Position', [0.705    0.725   0.285    0.2]);
hold on;
hold on;
for sample = 1:5
    plot(wavelength, trios_ramses.profiling(1).Luz(sample).raw, 'LineWidth', 0.5, 'Color', '[0,0,0]');
end
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 16, 'xticklabel', []);
box on;
grid on;
%title('L_{uz} Radiance')
ylabel('$L_u(5 cm)$','Interpreter','latex', 'FontName', 'Times', 'FontSize', 16)
hold off;

subplot('Position', [0.705    0.525   0.285    0.2]);
hold on;
hold on;
for sample = 1:5
    plot(wavelength, trios_ramses.profiling(2).Luz(sample).raw, 'LineWidth', 0.5, 'Color', '[0,0,0]');
end
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 16, 'xticklabel', []);
box on;
grid on;
ylabel('$L_u(10 cm)$','Interpreter','latex', 'FontName', 'Times', 'FontSize', 16)
hold off;

subplot('Position', [0.705    0.325   0.285    0.2]);
hold on;
hold on;
for sample = 1:5
    plot(wavelength, trios_ramses.profiling(3).Luz(sample).raw, 'LineWidth', 0.5, 'Color', '[0,0,0]');
end
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 16, 'xticklabel', []);
box on;
grid on;
ylabel('$L_u(15 cm)$','Interpreter','latex', 'FontName', 'Times', 'FontSize', 16)

subplot('Position', [0.705    0.125   0.285    0.2]);
hold on;
hold on;
for sample = 1:5
    plot(wavelength, trios_ramses.profiling(4).Luz(sample).raw, 'LineWidth', 0.5, 'Color', '[0,0,0]');
end
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 16);
box on;
grid on;
xlabel('Wavelength (nm)')
ylabel('$L_u(20 cm)$','Interpreter','latex', 'FontName', 'Times', 'FontSize', 16)

saveas(gcf, 'Report.png')
end
