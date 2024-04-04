clear
clc
tic


folder_path = uigetdir;

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
%%
stationN = lisstvsfStationInfo_1.filename;
figure('Position', [0, 0, 1920, 1080])
nRows = 3;
nCols = 3;
t = tiledlayout(nRows, nCols);
title(t, ['Station: ' stationN]);

nexttile;
plot(acsDeltaTimeSeconds, ExternalTemperature) %NaN in the sample file

title('External Temperature')
xlabel('Delta Time')
ylabel('Temperature (C)')
legend('External Temp')

nexttile;
hold on;
num_wL = size(at, 2); 
start_wL = 400; 
end_wL = 700; 
wavelengths = linspace(start_wL, end_wL, num_wL);

hold on;
for i = 1:size(at, 1) 
    plot(wavelengths, at(i, :), 'LineWidth', 2);
end
hold off;
xlabel('Wavelength (nm)');
ylabel('a (m^-^1)');
title('Absorption a_{t}');
hold off;

nexttile;
hold on;
hold on;
for i = 1:size(ct, 1) 
    plot(wavelengths, ct(i, :), 'LineWidth', 2);
end
hold off;
xlabel('Wavelength (nm)');
ylabel('a_{c}(m^-^1)');
title('Attenuation c_{t}');
hold off;

nexttile;
hold on;
yyaxis left
plot(ctdSampleRunJD, ctdSample(:,2))
xlabel('Time (JD)')
ylabel('Temperature (C)')
title('Temperature and Salinity over Time')
ax = gca;
ax.XAxis.Exponent = 0;

yyaxis right
plot(ctdSampleRunJD, ctdSample(:,1))
ylabel('Salinity')

hold off;

nexttile;
hold on;
wavelength = linspace(400, 700, 255);
hold on;
colors = {'#570AA1', '#CE42AF', '#5F52C8', '#BE91EB'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
    plot(wavelength, trios_ramses.profiling(depth).Lwp(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
title('L_{wp} Radiance')
xlabel('Wavelength (nm)')
ylabel('L_{wp}')
hold off;

nexttile;
hold on;
hold on;
colors = {'#570AA1', '#CE42AF', '#5F52C8', '#BE91EB'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
    plot(wavelength, trios_ramses.profiling(depth).Luz(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
title('L_{uz} Radiance')
xlabel('Wavelength (nm)')
ylabel('L_{uz}')
hold off;

nexttile;
hold on;
hold on;
colors = {'#570AA1', '#CE42AF', '#5F52C8', '#BE91EB'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
    plot(wavelength, trios_ramses.profiling(depth).Edp(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
title('E_{dp} Irradiance')
xlabel('Wavelength (nm)')
ylabel('E_{dp}')
hold off;

nexttile;
hold on;
hold on;
colors = {'#570AA1', '#CE42AF', '#5F52C8', '#BE91EB'};
labels = {'20 cm', '15 cm', '10 cm', '5 cm'};
for depth = 1:4
    for sample = 1:5
    plot(wavelength, trios_ramses.profiling(depth).Eop(sample).raw, 'LineWidth', 0.5, 'Color', colors{depth});
    end
end
hold off;
legend(labels);
title('E_{op} Radiance')
xlabel('Wavelength (nm)')
ylabel('E_{op}')
hold off;
