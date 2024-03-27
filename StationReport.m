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
nRows = 2;
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
cmap = winter(4);

for i = 1:numel(trios_ramses)
    for j = 1:numel(trios_ramses(i).Edp.raw)
        A(:,j) = trios_ramses(i).Lwp.raw(:,4)';
        B(:,j) = trios_ramses(i).Luz.raw(:,4)';
    end
    plot(A, 'Color', cmap(i,:));
    plot(B, 'Color', cmap(i,:));
end
title('Lwp/Luz')
hold off;

nexttile;
hold on;
cmap = winter(4);

for i = 1:numel(trios_ramses)
    for j = 1:numel(trios_ramses(i).Edp.raw)
        A(:,j) = trios_ramses(i).Edp.raw(:,4)';
        B(:,j) = trios_ramses(i).Eop.raw(:,4)';
    end
    plot(A, 'Color', cmap(i,:));
    plot(B, 'Color', cmap(i,:));
end
title('Edp/Eop')
hold off;

nexttile;
hold on;
num_wL = size(at, 2); 
start_wL = 400; 
end_wL = 700; 
wavelengths = linspace(start_wL, end_wL, num_wL);

hold on;
for i = 1:size(at, 1) 
    plot(wavelengths, at(i, :), 'LineWidth', 2);
    plot(wavelengths, ct(i, :), 'LineWidth', 2);
end
hold off;
xlabel('Wavelength (nm)');
ylabel('a(m^-^1)');
title('AC-s');
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
T = ctdSample(:,2);
S = ctdSample(:,1);
p0 = 999.842594+6.793952e-2.*T-9.095290e-3.*T.^2+1.001685e-4.*T.^3-1.120083e-6.*T.^4+6.536336e-9.*T.^5;
A = 8.24493e-1-4.0899e-3.*T+7.6438e-5.*T.^2-8.2467e-7.*T.^3+5.3875e-9.*T.^4;
B = 5.72466e-3+1.0227e-4.*T-1.6546e-6.*T.^2;
C = 4.8314e-4;

density = p0 + (A.*S) + (B.*S).^32 + (C.*S);




scatter(T, S, 50, density, 'filled');
colorbar;
ylabel('Salinity');
xlabel('Temperature (°C)');
title('T-S Diagram');
hold off;

