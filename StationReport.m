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
figure('Position', [0, 0, 1920, 1080])
nRows = 2;
nCols = 3;
t = tiledlayout(nRows, nCols);
title(t, 'Sample Report');

nexttile;
plot(ctdSampleRunJD, ctdSample(:,2))
title('CTD Data Over Time')
xlabel('Time (Julian Date)')
ylabel('CTD Data') 
ax = gca;
ax.XAxis.Exponent = 0;

nexttile;
plot(acsDeltaTimeSeconds, ct)
title('CT Over Time')
xlabel('Delta time')
ylabel('CT')

nexttile;
plot(acsDeltaTimeSeconds,at)
title('AT Over Time')
xlabel('Delta Time')
ylabel('AT')

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

toc
%%
plot(ctdSample(:,1), ctdSample(:,2))
title('CTD Data Over Time')
xlabel('Salinity')
ylabel('Temperature (C)') 
ax = gca;
ax.XAxis.Exponent = 0;
%%
num_wL = size(at, 2); 
start_wL = 400; 
end_wL = 700; 
wavelengths = linspace(start_wL, end_wL, num_wL);

figure;
hold on;
for i = 1:size(at, 1) 
    plot(wavelengths, at(i, :), 'LineWidth', 2);
    plot(wavelengths, ct(i, :), 'LineWidth', 2);
end
hold off;
xlabel('Wavelength (nm)');
ylabel('a(m^-^1)');
title('AC-s');