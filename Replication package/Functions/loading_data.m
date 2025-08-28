clear 
clc

N = 14; % number per session

% load tables %

Feb15_10am_nocharity = readtable('Experiment data\Feb15_10am_nocharity.xlsx','ReadVariableNames',true);
Feb15_2pm_charity = readtable('Experiment data\Feb15_2pm_charity.xlsx','ReadVariableNames',true);
Feb15_4pm_nocharity = readtable('Experiment data\Feb15_4pm_nocharity.xlsx','ReadVariableNames',true);

Feb17_10am_charity = readtable('Experiment data\Feb17_10am_charity.xlsx','ReadVariableNames',true);
Feb17_2pm_nocharity = readtable('Experiment data\Feb17_2pm_nocharity.xlsx','ReadVariableNames',true);
Feb17_4pm_charity = readtable('Experiment data\Feb17_4pm_charity.xlsx','ReadVariableNames',true);

Mar06_930am_nocharity = readtable('Experiment data\Mar06_930am_nocharity.xlsx','ReadVariableNames',true);
Mar06_1130am_charity = readtable('Experiment data\Mar06_1130am_charity.xlsx','ReadVariableNames',true);
Mar06_2pm_nocharity = readtable('Experiment data\Mar06_2pm_nocharity.xlsx','ReadVariableNames',true);
Mar06_4pm_charity = readtable('Experiment data\Mar06_4pm_charity.xlsx','ReadVariableNames',true);

Mar10_930am_charity = readtable('Experiment data\Mar10_930am_charity.xlsx','ReadVariableNames',true);
Mar10_1130am_nocharity = readtable('Experiment data\Mar10_1130am_nocharity.xlsx','ReadVariableNames',true);
Mar10_2pm_nocharity = readtable('Experiment data\Mar10_2pm_nocharity.xlsx','ReadVariableNames',true);
Mar10_4pm_charity = readtable('Experiment data\Mar10_4pm_charity.xlsx','ReadVariableNames',true);


% select the relevant variables %

Feb15_10am_nocharity = Feb15_10am_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);
Feb15_2pm_charity = Feb15_2pm_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);
Feb15_4pm_nocharity = Feb15_4pm_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);

Feb17_10am_charity = Feb17_10am_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);
Feb17_2pm_nocharity = Feb17_2pm_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);
Feb17_4pm_charity = Feb17_4pm_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);

Mar06_930am_nocharity = Mar06_930am_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);
Mar06_1130am_charity = Mar06_1130am_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);
Mar06_2pm_nocharity = Mar06_2pm_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);
Mar06_4pm_charity = Mar06_4pm_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);

Mar10_930am_charity = Mar10_930am_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);
Mar10_1130am_nocharity = Mar10_1130am_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);
Mar10_2pm_nocharity = Mar10_2pm_nocharity(:,[5:7 15:36 43:52 59:66 91:97 99:146 152:153 157:158 162:163 167:168 172:173 177:178 182:183 187:188 192:193 197:198 200]);
Mar10_4pm_charity = Mar10_4pm_charity(:,[5:7 15:36 43:52 59:70 95:101 103:150 156:157 161:162 166:167 171:172 176:177 181:182 186:187 191:192 196:197 201:202 204]);

% add group variables %

Feb15_10am_nocharity.Group = ones(N,1);
Feb15_2pm_charity.Group = ones(N,1).*2;
Feb15_4pm_nocharity.Group = ones(N,1).*3;

Feb17_10am_charity.Group = ones(N,1).*4;
Feb17_2pm_nocharity.Group = ones(N,1).*5;
Feb17_4pm_charity.Group = ones(N,1).*6;

Mar06_930am_nocharity.Group = ones(N,1).*7;
Mar06_1130am_charity.Group = ones(N,1).*8;
Mar06_2pm_nocharity.Group = ones(N,1).*9;
Mar06_4pm_charity.Group = ones(N,1).*10;

Mar10_930am_charity.Group = ones(N,1).*11;
Mar10_1130am_nocharity.Group = ones(N,1).*12;
Mar10_2pm_nocharity.Group = ones(N,1).*13;
Mar10_4pm_charity.Group = ones(N,1).*14;

% join tables %

NoCharity = [Feb15_10am_nocharity; Feb15_4pm_nocharity; Feb17_2pm_nocharity; Mar06_930am_nocharity; Mar06_2pm_nocharity; Mar10_1130am_nocharity; Mar10_2pm_nocharity];

Charity =[Feb15_2pm_charity; Feb17_10am_charity; Feb17_4pm_charity; Mar06_1130am_charity; Mar06_4pm_charity; Mar10_930am_charity; Mar10_4pm_charity];

