%{
 
Class: CECS 271 

Student: James Henry 

Program: BloodPressureAnalysis.m

Goal: Create a program that reads blood pressure data, and provides 
insights to health trends.

%}

%% STEP 1: Import CSV, or excel file
T = readtable("BloodPressureData.csv"); % Uncomment for CSV file
% T = readtable("BloodPressureData.xlsx"); % Uncomment for Excel file 

% Preallocating an empty column for blood pressure classification
T.BP_Status = strings(height(T), 1);

% Checks if there are any negative entries in the input file 
if any(T.Systolic < 0) || any(T.Diastolic < 0)
    error('Negative blood pressure values are invalid.');
end 

% Also checks for missing values in the input file 
if any(ismissing(T(:, {'Systolic', 'Diastolic'})))
    error('Missing blood pressure values detected. Check the data.');
end

%% Classifies each patient by their conditions 
for i = 1:height(T)
    x = T.Systolic(i); % for all Systolic
    y = T.Diastolic(i); % for all Diastolic

% I checked conditions from most->least severe to ensure accurate classification.
% Doing it this way also optimizes performance by reducing unnecessary checks 
% and prevents less severe conditions from overwriting more critical ones.

    % Case 5: Hypertensive crisis
    if x >= 180 || y >= 120
        T.BP_Status(i) = "HYPERTENSIVE CRISIS";

    % Case 4: Hypertension stage 2 
    elseif (x >= 140 && x <= 179) || (y >= 90 && y <= 119)
        T.BP_Status(i) = "HYPERTENSION STAGE 2";

    % Case 3: Hypertension Stage 1 
    elseif (x >= 130 && x <= 139) || (y >= 80 && y <= 89)
        T.BP_Status(i) = "HYPERTENSION STAGE 1";

    % Case 2: Elevated BP
    elseif x >= 120 && x <= 129 && y < 80
        T.BP_Status(i) = "ELEVATED";

    % Case 1: Normal BP
    elseif x < 120 && y < 80
        T.BP_Status(i) = "NORMAL";

    % Case 6: Undefined category
    else
        T.BP_Status(i) = "UNDEFINED";
    end
end


%% Displays data from the CSV/XLSX file in the command window
disp(T(:, ["Name", "Systolic", "Diastolic", "BP_Status"]))

%% Creates bar graph for each patient and their classification
bpCategories = categories(categorical(T.BP_Status));

% Order of categories (cell array)
desiredOrder = {'NORMAL', 'ELEVATED', 'HYPERTENSION STAGE 1', 'HYPERTENSION STAGE 2', 'HYPERTENSIVE CRISIS', 'UNDEFINED'};

% Colormap for categories (matrix)
statusColors = [0 1 0;   % Green - 'NORMAL'
                1 1 0;   % Yellow - 'ELEVATED'
                1 0.5 0; % Orange - 'HYPERTENSION STAGE 1'
                1 0 0;   % Red - 'HYPERTENSION STAGE 2'
                0.5 0 0.5 % Purple - 'HYPERTENSIVE CRISIS'
                0.7 0.7 0.7  % Gray
                ]; 

allCategories = {'NORMAL', 'ELEVATED', 'HYPERTENSION STAGE 1', ...
                 'HYPERTENSION STAGE 2', 'HYPERTENSIVE CRISIS', 'UNDEFINED'};

% Count occurrences (including zero counts)
bpCounts = zeros(size(allCategories));
for i = 1:length(allCategories)
    bpCounts(i) = sum(strcmp(T.BP_Status, allCategories{i}));
end

% Plot
figure;
bars = bar(bpCounts, 'FaceColor', 'flat');
bars.CData = statusColors; % Assign colors
set(gca, 'XTickLabel', allCategories, 'XTickLabelRotation', 45);
title('Blood Pressure Classification');

%% STEP 2: Calculate average systolic and diastolic values
avgSystolic = mean(T.Systolic);
avgDiastolic = mean(T.Diastolic);

fprintf('Average Systolic Pressure: %.2f mmHg\n', avgSystolic);
fprintf('Average Diastolic Pressure: %.2f mmHg\n', avgDiastolic);

%% Step 3:Plot blood pressure trends over time and highlight critical ranges
patientIndex = 1:height(T);

figure;
plot(patientIndex, T.Systolic, patientIndex, T.Diastolic);
hold on;
yline(140, '--r', 'Systolic Stage 2 Threshold');
yline(90, '--m', 'Diastolic Stage 2 Threshold');

% I decided to plot individual points using a for loop
for i = 1:length(patientIndex)
    scatter(patientIndex(i), T.Systolic(i), 'r', 'filled'); % Red circles for Systolic points
    scatter(patientIndex(i), T.Diastolic(i), 'b', 'filled'); % Blue circles for Diastolic points
end
xlabel('Patient Index');
ylabel('Blood Pressure (mmHg)');
title('Blood Pressure Trends Across Patients');
legend('Systolic', 'Diastolic');
grid on;

%{

%% GitHub Repository Link:
 https://github.com/j3meshenry/BloodPressureDataAnalysis/tree/main

%% Sources/Resources 
1. 
Solan, M. (2022, April 1). A look at diastolic blood pressure. 
Harvard Health. 
https://www.health.harvard.edu/heart-health/a-look-at-diastolic-b
lood-pressure#:~:text=Diastolic%20pressure%20is%20the%20pressure%20during%20the,
to%20the%20heart%20muscle%2C%22%20says%20Dr.%20Juraschek 

2. 
PREALLOCATION:
https://www.mathworks.com/help/matlab/matlab_prog/preallocating-arrays.html

3.
CREATE BAR GRAPH:
https://www.mathworks.com/help/matlab/ref/bar.html

4. 
RGB: 
https://www.rapidtables.com/web/color/RGB_Color.html?form=MG0AV3

%}
