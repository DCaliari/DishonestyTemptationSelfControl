clear
clc

addpath(fullfile(pwd,'Functions'));

loading_data % loading data --- see function

%% Matrix of switching points

MPL_switches_NoCharity = [];
MPL_times_NoCharity = [];

MPL_switches_Charity = [];
MPL_times_Charity = [];

for i=1:11
    str = num2str(i);
        MPL_switches_NoCharity = [MPL_switches_NoCharity, NoCharity.(['MPL_' str '_'])]; %#ok<AGROW> 
        MPL_times_NoCharity = [MPL_times_NoCharity, NoCharity.(['MPLtime_' str '_'])]; %#ok<AGROW> 

        MPL_switches_Charity = [MPL_switches_Charity, Charity.(['MPL_' str '_'])]; %#ok<AGROW> 
        MPL_times_Charity = [MPL_times_Charity, Charity.(['MPLtime_' str '_'])]; %#ok<AGROW> 
end


%% Sample sizes

N_nocharity = size(MPL_switches_NoCharity,1); % total number charity
N_charity = size(MPL_switches_Charity,1); % total number no-charity

%% Analysis Switching points 

% Search for multiple switching points

MSB_NoCharity = zeros(N_nocharity,1);
for i=1:N_nocharity
    for j=1:10
        if MPL_switches_NoCharity(i,j+1)>MPL_switches_NoCharity(i,j)
            MSB_NoCharity(i,j) = 1;
        else
            MSB_NoCharity(i,j) = 0;
        end
    end
end

MSB_NoCharity = sum(MSB_NoCharity,2)>0;


MSB_Charity = zeros(N_charity,1);
for i=1:N_charity
    for j=1:10
        if MPL_switches_Charity(i,j+1)>MPL_switches_Charity(i,j)
            MSB_Charity(i,j) = 1;
        else
            MSB_Charity(i,j) = 0;
        end
    end
end

MSB_Charity = sum(MSB_Charity,2)>0;


Switching_points_NoCharity = sum(MPL_switches_NoCharity==1,2);

Win_NoCharity = strcmp(NoCharity.Win_Lose,'w');

Private_NoCharity = NoCharity.selected_mpl;


Switching_points_Charity = sum(MPL_switches_Charity==1,2);

Win_Charity = strcmp(Charity.Win_Lose,'w');

Private_Charity = Charity.selected_mpl;

%% Plots distributions SP: FIGURE 3


cat = categorical(["p=1","p=0.8","p=0.6","p=0.55","p=0.5","p=0.45","p=0.4","p=0.3","p=0.2","p=0.1","p=0","NS"]);
cat = reordercats(cat,["p=1","p=0.8","p=0.6","p=0.55","p=0.5","p=0.45","p=0.4","p=0.3","p=0.2","p=0.1","p=0","NS"]);
for i=1:12
pNoCh(1,i) = sum(Switching_points_NoCharity(MSB_NoCharity==0)==(i-1))/length(Switching_points_NoCharity(MSB_NoCharity==0));
pCh(1,i) = sum(Switching_points_Charity(MSB_Charity==0)==(i-1))/length(Switching_points_Charity(MSB_Charity==0));
end
pTot = [pNoCh;pCh];
bar(cat, pTot)
ylim([0 0.4])
legend('\bf no-charity', '\bf charity')
xlabel('Prob. of the Public Lottery at the Switching Point', 'FontName', 'Times')
ylabel('Frequency', 'FontName', 'Times')
set(gca,'FontName','Times')

for i=1:12
binsNoCh(1,i) = sum(Switching_points_NoCharity(MSB_NoCharity==0)==(i-1));
binsCh(1,i) = sum(Switching_points_Charity(MSB_Charity==0)==(i-1));
end

%% FISHER EXACT TESTS - PG. 22 --- distribution comparisons

fisher_test_R_C([binsNoCh' binsCh'], 100000)

fisher_test_R_C([binsNoCh(1:6)' binsCh(1:6)'], 100000)

%% CREATING VARIABLES BY POOLING DATA

Male = [NoCharity.Gender==2; Charity.Gender==2];

SP = [Switching_points_NoCharity; Switching_points_Charity];

MSB = [MSB_NoCharity; MSB_Charity];

WIN = [Win_NoCharity; Win_Charity];

Priv = [Private_NoCharity; Private_Charity];

ch = [zeros(98,1);ones(98,1)];
ch=logical(ch);



%% Winning share by SPs: FIGURE 4

% winning share when p < 0.5, p = 0.5, p > 0.5
ProbW_type3 = [sum(MSB==0 & Priv == -1 & WIN & SP<4)/sum(MSB==0 & Priv == -1 & SP<4)
    sum(MSB==0 & Priv == -1 & WIN & SP==4)/sum(MSB==0 & Priv == -1 & SP==4)
    sum(MSB==0 & Priv == -1 & WIN & SP>=5)/sum(MSB==0 & Priv == -1 & SP>=5)];
phat_type3 = ProbW_type3';

% standard errors
st_err3 = [sqrt((sum(MSB==0 & Priv == -1 & WIN & SP<4)/sum(MSB==0 & Priv == -1 & SP<4))*(1-sum(MSB==0 & Priv == -1 & WIN & SP<4)/sum(MSB==0 & Priv == -1 & SP<4))/sum(MSB==0 & Priv == -1 & SP<4))
sqrt((sum(MSB==0 & Priv == -1 & WIN & SP==4)/sum(MSB==0 & Priv == -1 & SP<4))*(1-sum(MSB==0 & Priv == -1 & WIN & SP==4)/sum(MSB==0 & Priv == -1 & SP<4))/sum(MSB==0 & Priv == -1 & SP==4))
sqrt((sum(MSB==0 & Priv == -1 & WIN & SP>=5)/sum(MSB==0 & Priv == -1 & SP<4))*(1-sum(MSB==0 & Priv == -1 & WIN & SP>=5)/sum(MSB==0 & Priv == -1 & SP<4))/sum(MSB==0 & Priv == -1 & SP>=5))];

se_types3 = [(ProbW_type3+st_err3)';(ProbW_type3-st_err3)'];


j=3;
cat = categorical({'p > 0.5', 'p = 0.5', 'p < 0.5'});
cat = reordercats(cat,{'p > 0.5', 'p = 0.5', 'p < 0.5'});
plot(cat,phat_type3(1:j),'*','MarkerSize',8)
hold on
errorbar(cat,phat_type3(1:j),phat_type3(1:j)-se_types3(1,1:j),se_types3(2,1:j)-phat_type3(1:j),'LineStyle','none','Linewidth',1.1)
hold off 
ylim([0 1.05])
yline(0.5,'--')
yline(1,'--')
ylabel('Winning share')
xlabel('Prob. of the Public Lottery at the Switching Point', 'FontName', 'Times')
legend('ML winning share','Standard errors')
set(gca,'FontName','Times')



%% TYPES DISTRIBUTION -- PG. 25 and FOOTNOTE 18

% We apply formula at pg. 25 to find the proportion of cheaters 
% pc = 2w - 1; the proportion of non-cheaters  is 1- pc = 1 - 2w + 1

Type1 = (2*ProbW_type3(1) - 1)*( sum(MSB==0 & SP < 4)/sum(MSB==0)) + (2*ProbW_type3(2) - 1)*( sum(MSB==0 & SP == 4)/sum(MSB==0));  % cheaters
Type4 = (1 - 2*ProbW_type3(2) + 1)*(sum(MSB==0 & SP == 4)/sum(MSB==0)) + (1 - 2* sum(MSB==0 & Priv == -1 & WIN & SP==5)/sum(MSB==0 & Priv == -1 & SP==5) + 1)*( sum(MSB==0 & SP == 5)/sum(MSB==0));  % honest not tempted
Type3 = ( sum(MSB==0 & SP > 5)/sum(MSB==0));  % honest tempted who resisted temptation
TypeFail2beCategorized = (1 - 2*ProbW_type3(1) + 1)*( sum(MSB==0 & SP < 4)/sum(MSB==0)) + (2* sum(MSB==0 & Priv == -1 & WIN & SP==5)/sum(MSB==0 & Priv == -1 & SP==5) - 1)*( sum(MSB==0 & SP == 5)/sum(MSB==0));
 

%% Winning share by SPs and by treatment: FIGURE 5

% winning share when p < 0.5, p = 0.5, p > 0.5 in the charity treatment
ProbW_ch_type = [sum(MSB==0 & Priv == -1 & WIN & SP<4 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch)
    sum(MSB==0 & Priv == -1 & WIN & SP==4 & ch)/sum(MSB==0 & Priv == -1 & SP==4 & ch)
    sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ch)/sum(MSB==0 & Priv == -1 & SP>=5 & ch)];
phat_ch_type2 = ProbW_ch_type';

% winning share when p < 0.5, p = 0.5, p > 0.5 in the baseline treatment
ProbW_nch_type = [sum(MSB==0 & Priv == -1 & WIN & SP<4 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch)
    sum(MSB==0 & Priv == -1 & WIN & SP==4 & ~ch)/sum(MSB==0 & Priv == -1 & SP==4 & ~ch)
    sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ~ch)/sum(MSB==0 & Priv == -1 & SP>=5 & ~ch)];
phat_nch_type2 = ProbW_nch_type';

% standard errors
st_err3_ch = [sqrt((sum(MSB==0 & Priv == -1 & WIN & SP<4 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch))*(1-sum(MSB==0 & Priv == -1 & WIN & SP<4 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch))/sum(MSB==0 & Priv == -1 & SP<4 & ch))
sqrt((sum(MSB==0 & Priv == -1 & WIN & SP==4 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch))*(1-sum(MSB==0 & Priv == -1 & WIN & SP==4 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch))/sum(MSB==0 & Priv == -1 & SP==4 & ch))
sqrt((sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch))*(1-sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ch)/sum(MSB==0 & Priv == -1 & SP<4 & ch))/sum(MSB==0 & Priv == -1 & SP>=5 & ch))];

st_err3_nch = [sqrt((sum(MSB==0 & Priv == -1 & WIN & SP<4 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))*(1-sum(MSB==0 & Priv == -1 & WIN & SP<4 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))
sqrt((sum(MSB==0 & Priv == -1 & WIN & SP==4 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))*(1-sum(MSB==0 & Priv == -1 & WIN & SP==4 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))/sum(MSB==0 & Priv == -1 & SP==4 & ~ch))
sqrt((sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))*(1-sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ~ch)/sum(MSB==0 & Priv == -1 & SP<4 & ~ch))/sum(MSB==0 & Priv == -1 & SP>=5 & ~ch))];

se_types3_ch = [(ProbW_ch_type+st_err3_ch)';(ProbW_ch_type-st_err3_ch)'];
se_types3_nch = [(ProbW_nch_type+st_err3_nch)';(ProbW_nch_type-st_err3_nch)'];

cat = categorical({'p > 0.5', 'p = 0.5', 'p < 0.5'});
cat = reordercats(cat,{'p > 0.5', 'p = 0.5', 'p < 0.5'});

t = tiledlayout(1,2); % 1 row, 2 columns
nexttile
plot(cat,phat_ch_type2(1:3),'*','MarkerSize',8)
hold on
errorbar(cat,phat_ch_type2(1:3),phat_ch_type2(1:3)-se_types3_ch(1,1:3),se_types3_ch(2,1:3)-phat_ch_type2(1:3),'LineStyle','none','Linewidth',1.1)
hold off
ylim([0.1 1.05])
yline(0.5,'--')
yline(1,'--')
ylabel('Winning share')
title('Charity')
legend('ML winning share','Standard errors')
set(gca,'FontName','Times')
nexttile
plot(cat,phat_nch_type2(1:3),'*','MarkerSize',8)
hold on
errorbar(cat,phat_nch_type2(1:3),phat_nch_type2(1:3)-se_types3_nch(1,1:3),se_types3_nch(2,1:3)-phat_nch_type2(1:3),'LineStyle','none','Linewidth',1.1)
hold off
ylim([0.1 1.05])
yline(0.5,'--')
yline(1,'--')
ylabel('Winning share')
title('No-Charity')
legend('ML winning share','Standard errors')
set(gca,'FontName','Times')
hold off
xlabel(t, 'Prob. of the Public Lottery at the Switching Point', 'FontName', 'Times')

%% FISHER EXACT TESTS - PG. 26 --- comparison winning shares

x1 = [sum(MSB==0 & Priv == -1 & WIN & SP<4 & ch),sum(MSB==0 & Priv == -1 & WIN & SP<4 & ~ch)
            sum(MSB==0 & Priv == -1 & ~WIN & SP<4 & ch), sum(MSB==0 & Priv == -1 & ~WIN & SP<4 & ~ch)];

x2 = [sum(MSB==0 & Priv == -1 & WIN & SP==4 & ch),sum(MSB==0 & Priv == -1 & ~WIN & SP==4 & ch)
            sum(MSB==0 & Priv == -1 & WIN & SP==4 & ~ch), sum(MSB==0 & Priv == -1 & ~WIN & SP==4 & ~ch)];

x3 = [sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ch),sum(MSB==0 & Priv == -1 & WIN & SP>=5 & ~ch)
            sum(MSB==0 & Priv == -1 & ~WIN & SP>=5 & ch), sum(MSB==0 & Priv == -1 & ~WIN & SP>=5 & ~ch)];


fisher_test_R_C(x1)
fisher_test_R_C(x2)
fisher_test_R_C(x3)


%% Response times MPL

TimesMPL_NoCharity = [NoCharity.MPLtime_1_,NoCharity.MPLtime_2_,NoCharity.MPLtime_3_,NoCharity.MPLtime_4_,NoCharity.MPLtime_5_,NoCharity.MPLtime_6_,NoCharity.MPLtime_7_,NoCharity.MPLtime_8_,...
    NoCharity.MPLtime_9_,NoCharity.MPLtime_10_,NoCharity.MPLtime_11_];

TimesMPL_Charity = [Charity.MPLtime_1_,Charity.MPLtime_2_,Charity.MPLtime_3_,Charity.MPLtime_4_,Charity.MPLtime_5_,Charity.MPLtime_6_,Charity.MPLtime_7_,Charity.MPLtime_8_,...
    Charity.MPLtime_9_,Charity.MPLtime_10_,Charity.MPLtime_11_];

TimesMPL = [TimesMPL_NoCharity; TimesMPL_Charity];


mTimesMPL_cheat = mean(TimesMPL(SP<4 & MSB==0,:));
sTimesMPL_cheat = std(TimesMPL(SP<4 & MSB==0,:))./sqrt(size(TimesMPL(SP<4 & MSB==0),1));

mTimesMPL_med = mean(TimesMPL(SP==4 & MSB==0,:));
sTimesMPL_med = std(TimesMPL(SP==4 & MSB==0,:))./sqrt(size(TimesMPL(SP==4 & MSB==0),1));

mTimesMPL_honest = mean(TimesMPL(SP>4 & MSB==0,:));
sTimesMPL_honest = std(TimesMPL(SP>4 & MSB==0,:))./sqrt(size(TimesMPL(SP>4 & MSB==0),1));

yse_honest = [-sTimesMPL_honest;sTimesMPL_honest];
yes_med = [-sTimesMPL_med;sTimesMPL_med];
yse_cheat = [-sTimesMPL_cheat;sTimesMPL_cheat];

% Figure B.3

cat = categorical(["p=1","p=0.8","p=0.6","p=0.55","p=0.5","p=0.45","p=0.4","p=0.3","p=0.2","p=0.1","p=0"]);
cat = reordercats(cat,["p=1","p=0.8","p=0.6","p=0.55","p=0.5","p=0.45","p=0.4","p=0.3","p=0.2","p=0.1","p=0"]);
errorbar(cat, mTimesMPL_cheat, yse_cheat(1,:),'LineWidth',1.3)
hold on 
errorbar(cat, mTimesMPL_med, yes_med(1,:),'LineWidth',1.3)
hold on
errorbar(cat, mTimesMPL_honest, yse_honest(1,:),'LineWidth',1.3)
hold off
legend('p > 0.5', 'p = 0.5', 'p < 0.5')
xlabel('Prob. of winning Public Lottery')
ylabel('seconds')
set(gca,'FontName','Times')



%% Personality traits - file 48QB6.pdf
% instructions to build the indexes are in the file
% 48QB6-Scoring-Psychometrics.pdf

Honesty1_NC = [NoCharity.R5, NoCharity.R11, NoCharity.R29, NoCharity.R47];
Honesty2_NC = [NoCharity.R17, NoCharity.R35, NoCharity.R38, NoCharity.R41];

Honesty1_C = [Charity.R5, Charity.R11, Charity.R29, Charity.R47];
Honesty2_C = [Charity.R17, Charity.R35, Charity.R38, Charity.R41];

Honesty1 = [Honesty1_NC; Honesty1_C];
Honesty2 = [Honesty2_NC; Honesty2_C];

Honesty = ((sum(Honesty1,2) + (20-sum(Honesty2,2)))./8).*20;

mean(((sum(Honesty1,2) + (20-sum(Honesty2,2)))./8))
std(((sum(Honesty1,2) + (20-sum(Honesty2,2)))./8))

Agreeableness1_NC = [NoCharity.R2, NoCharity.R8, NoCharity.R44];
Agreeableness2_NC = [NoCharity.R14, NoCharity.R20, NoCharity.R23, NoCharity.R26, NoCharity.R32];

Agreeableness1_C = [Charity.R2, Charity.R8, Charity.R44];
Agreeableness2_C = [Charity.R14, Charity.R20, Charity.R23, Charity.R26, Charity.R32];

Agreeableness1 = [Agreeableness1_NC; Agreeableness1_C];
Agreeableness2 = [Agreeableness2_NC; Agreeableness2_C];

Agreeableness = ((sum(Agreeableness1,2) + (25-sum(Agreeableness2,2)))./8).*20;

mean(((sum(Agreeableness1,2) + (25-sum(Agreeableness2,2)))./8))
std(((sum(Agreeableness1,2) + (25-sum(Agreeableness2,2)))./8))

Resiliency1_NC = [NoCharity.R12, NoCharity.R42, NoCharity.R48];
Resiliency2_NC = [NoCharity.R6, NoCharity.R18, NoCharity.R24, NoCharity.R30, NoCharity.R36];

Resiliency1_C = [Charity.R12, Charity.R42, Charity.R48];
Resiliency2_C = [Charity.R6, Charity.R18, Charity.R24, Charity.R30, Charity.R36];

Resiliency1 = [Resiliency1_NC; Resiliency1_C];
Resiliency2 = [Resiliency2_NC; Resiliency2_C];

Resiliency = ((sum(Resiliency1,2) + (25-sum(Resiliency2,2)))./8).*20;

mean(((sum(Resiliency1,2) + (25-sum(Resiliency2,2)))./8))
std(((sum(Resiliency1,2) + (25-sum(Resiliency2,2)))./8))

Extraversion1_NC = [NoCharity.R3, NoCharity.R9, NoCharity.R15, NoCharity.R45];
Extraversion2_NC = [NoCharity.R21, NoCharity.R27, NoCharity.R33, NoCharity.R39];

Extraversion1_C = [Charity.R3, Charity.R9, Charity.R15, Charity.R45];
Extraversion2_C = [Charity.R21, Charity.R27, Charity.R33, Charity.R39];

Extraversion1 = [Extraversion1_NC; Extraversion1_C];
Extraversion2 = [Extraversion2_NC; Extraversion2_C];

Extraversion = ((sum(Extraversion1,2) + (20-sum(Extraversion2,2)))./8).*20;

mean(((sum(Extraversion1,2) + (20-sum(Extraversion2,2)))./8))
std(((sum(Extraversion1,2) + (20-sum(Extraversion2,2)))./8))

Originality1_NC = [NoCharity.R4, NoCharity.R10, NoCharity.R34, NoCharity.R46];
Originality2_NC = [NoCharity.R16, NoCharity.R22, NoCharity.R25, NoCharity.R40];

Originality1_C = [Charity.R4, Charity.R10, Charity.R34, Charity.R46];
Originality2_C = [Charity.R16, Charity.R22, Charity.R25, Charity.R40];

Originality1 = [Originality1_NC; Originality1_C];
Originality2 = [Originality2_NC; Originality2_C];

Originality = ((sum(Originality1,2) + (20-sum(Originality2,2)))./8).*20;

mean(((sum(Originality1,2) + (20-sum(Originality2,2)))./8))
std(((sum(Originality1,2) + (20-sum(Originality2,2)))./8))

Conscientiousness1_NC = [NoCharity.R1, NoCharity.R7, NoCharity.R13, NoCharity.R43];
Conscientiousness2_NC = [NoCharity.R19, NoCharity.R28, NoCharity.R31, NoCharity.R37];

Conscientiousness1_C = [Charity.R1, Charity.R7, Charity.R13, Charity.R43];
Conscientiousness2_C = [Charity.R19, Charity.R28, Charity.R31, Charity.R37];

Conscientiousness1 = [Conscientiousness1_NC; Conscientiousness1_C];
Conscientiousness2 = [Conscientiousness2_NC; Conscientiousness2_C];

mean(((sum(Conscientiousness1,2) + (20-sum(Conscientiousness2,2)))./8))
std(((sum(Conscientiousness1,2) + (20-sum(Conscientiousness2,2)))./8))

Conscientiousness = ((sum(Conscientiousness1,2) + (20-sum(Conscientiousness2,2)))./8).*20;


[wilc(1,1),wilc(1,2),~] = ranksum(Honesty(SP<4 & MSB==0),Honesty(SP>4 & MSB==0));
[wilc(2,1),wilc(2,2),~] = ranksum(Conscientiousness(SP<4 & MSB==0),Conscientiousness(SP>4 & MSB==0));


% Figure B.4

cat = categorical({'p > 0.5', 'p = 0.5', 'p < 0.5'});
cat = reordercats(cat,{'p > 0.5', 'p = 0.5', 'p < 0.5'});
subplot(3,2,1)
al_goodplot(Honesty(SP<4 & MSB==0), 1,0.3)
al_goodplot(Honesty(SP==4 & MSB==0), 2,0.3)
al_goodplot(Honesty(SP>4 & MSB==0), 3,0.3)
set(gca,'xtick',1:1:3,'xticklabel',cat)
ylim([0 100])
title('Honesty')
set(gca,'FontName','Times')
subplot(3,2,2)
al_goodplot(Agreeableness(SP<4 & MSB==0), 1,0.3)
al_goodplot(Agreeableness(SP==4 & MSB==0), 2,0.3)
al_goodplot(Agreeableness(SP>4 & MSB==0), 3,0.3)
set(gca,'xtick',1:1:3,'xticklabel',cat)
ylim([0 100])
title('Agreeableness')
set(gca,'FontName','Times')
subplot(3,2,3)
al_goodplot(Resiliency(SP<4 & MSB==0), 1,0.3)
al_goodplot(Resiliency(SP==4 & MSB==0), 2,0.3)
al_goodplot(Resiliency(SP>4 & MSB==0), 3,0.3)
ylim([0 100])
set(gca,'xtick',1:1:3,'xticklabel',cat)
title('Resiliency')
set(gca,'FontName','Times')
subplot(3,2,4)
al_goodplot(Extraversion(SP<4 & MSB==0), 1,0.3)
al_goodplot(Extraversion(SP==4 & MSB==0), 2,0.3)
al_goodplot(Extraversion(SP>4 & MSB==0), 3,0.3)
ylim([0 100])
set(gca,'xtick',1:1:3,'xticklabel',cat)
title('Extraversion')
set(gca,'FontName','Times')
subplot(3,2,5)
al_goodplot(Originality(SP<4 & MSB==0), 1,0.3)
al_goodplot(Originality(SP==4 & MSB==0), 2,0.3)
al_goodplot(Originality(SP>4 & MSB==0), 3,0.3)
ylim([0 100])
set(gca,'xtick',1:1:3,'xticklabel',cat)
title('Originality')
set(gca,'FontName','Times')
subplot(3,2,6)
al_goodplot(Conscientiousness(SP<4 & MSB==0), 1,0.3)
al_goodplot(Conscientiousness(SP==4 & MSB==0), 2,0.3)
al_goodplot(Conscientiousness(SP>4 & MSB==0), 3,0.3)
ylim([0 100])
set(gca,'xtick',1:1:3,'xticklabel',cat)
title('Conscientiousness')
set(gca,'FontName','Times')

%% Create variables for TABLES 3 and 4

%% Demographics

[Economists, Engineers, Maths, Social] = fieldstudy(NoCharity,Charity);

STEM = Maths | Engineers;


%% Raven

Raven_choices_NoCharity = [];
Raven_choices_Charity = [];

Raven_results_NoCharity = [];
Raven_results_Charity = [];

Raven_time_NoCharity = [];
Raven_time_Charity = [];

for i=1:10
    str = num2str(i);
        Raven_choices_NoCharity = [Raven_choices_NoCharity, NoCharity.(['Raven' str '_Choice'])]; %#ok<AGROW> 
        Raven_choices_Charity = [Raven_choices_Charity, Charity.(['Raven' str '_Choice'])]; %#ok<AGROW> 

        Raven_results_NoCharity = [Raven_results_NoCharity, NoCharity.(['Raven' str '_Correct'])]; %#ok<AGROW> 
        Raven_results_Charity = [Raven_results_Charity, Charity.(['Raven' str '_Correct'])]; %#ok<AGROW> 

        Raven_time_NoCharity = [Raven_time_NoCharity, NoCharity.(['ResponseTime_Raven_' str])]; %#ok<AGROW> 
        Raven_time_Charity = [Raven_time_Charity, Charity.(['ResponseTime_Raven_' str])]; %#ok<AGROW> 
end

Raven = [sum(Raven_results_NoCharity,2); sum(Raven_results_Charity,2)];
Raven_time = [sum(Raven_time_NoCharity,2); sum(Raven_time_Charity,2)];

%% Gender

Male_SP_Charity = Switching_points_Charity(MSB_Charity==0 & Charity.Gender==2);
Female_SP_Charity = Switching_points_Charity(MSB_Charity==0 & Charity.Gender==1);

Male_SP_NoCharity = Switching_points_NoCharity(MSB_NoCharity==0 & NoCharity.Gender==2);
Female_SP_NoCharity = Switching_points_NoCharity(MSB_NoCharity==0 & NoCharity.Gender==1);

Male_SP = [Male_SP_NoCharity; Male_SP_Charity];
Female_SP = [Female_SP_NoCharity; Female_SP_Charity];


%% construct the dataset for regression

Group =[NoCharity.Group;Charity.Group];
Age = [NoCharity.Age;Charity.Age];
Germans = nationality(NoCharity, Charity);

Germans_lang = language(NoCharity, Charity);
Dataset = [Agreeableness, Conscientiousness, Extraversion, Resiliency, Honesty, Originality, ch, Economists, Engineers, Maths, Social, STEM, Male, MSB, Priv, Raven, Raven_time, TimesMPL, SP, WIN, Group,...
    Age, Germans, Germans_lang];

DATASET = array2table(Dataset,"VariableNames",["Agreeableness","Conscientiousness","Extraversion", "Resiliency","Honesty","Originality","Charity","Economists","Engineers","Maths","Social","STEM","Male",...
    "MSB","Private","Raven","RavenTime","TimesMPL1","TimesMPL2","TimesMPL3","TimesMPL4","TimesMPL5","TimesMPL6","TimesMPL7","TimesMPL8","TimesMPL9","TimesMPL10","TimesMPL11"...
    "SP","WIN","Group","Age","German","GermanLang"]);

writetable(DATASET,'TempSelfControl.csv')
