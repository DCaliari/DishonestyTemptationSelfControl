function Germans = nationality(NoCharity, Charity)

par = 'German';
Germans_NoCharity = contains(NoCharity.Nationality,par);
par = 'german';
Germans_NoCharity = Germans_NoCharity+ contains(NoCharity.Nationality,par);
Germans_NoCharity = Germans_NoCharity>0;

par = 'German';
Germans_Charity = contains(Charity.Nationality,par);
par = 'german';
Germans_Charity = Germans_Charity+ contains(Charity.Nationality,par);
Germans_Charity = Germans_Charity>0;

Germans = [Germans_NoCharity; Germans_Charity];

end
