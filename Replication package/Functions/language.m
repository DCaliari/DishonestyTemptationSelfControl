function Germans_lang = language(NoCharity, Charity)

par = 'German';
Germans_lang_NoCharity = contains(NoCharity.Language,par);
par = 'german';
Germans_lang_NoCharity = Germans_lang_NoCharity+ contains(NoCharity.Language,par);
Germans_lang_NoCharity = Germans_lang_NoCharity>0;

par = 'German';
Germans_lang_Charity = contains(Charity.Language,par);
par = 'german';
Germans_lang_Charity = Germans_lang_Charity+ contains(Charity.Language,par);
Germans_lang_Charity = Germans_lang_Charity>0;

Germans_lang = [Germans_lang_NoCharity; Germans_lang_Charity];

end
