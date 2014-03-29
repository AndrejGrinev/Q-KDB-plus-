.z.P
tg: ("ISSSSSSSSSSSSSSS"; enlist ",") 0:`bfinf_other_081013to081019_081022123301.csv 
/=====================================================================================================================================================
repldat:{[b1] s1:b1; z1:s1[0,1];z2:s1[3,4];z3:s1[6,7,8,9];z4:s1[11,12,13,14,15,16,17,18];z5:z3,".",z2,".",z1,"T",z4,".000";:"Z" $ z5 }
replfu:{[s1]  z1:s1 ss "/" ; z2:max z1 ; z3:count s1; z4:z3-z2 ; z4:z4-1 ; iz:1; z5:"" ; do[z4; z5:z5,s1[z2+iz] ; iz+:1 ] ; : z5}
all_tennis_inplay1:([] i:();  ev_id:(); se_da:(); fu_de:(); sc_of:(); ev:();  se_id:(); se:(); od:(); nu_be:(); vo_ma:(); la_ta:(); fi_ta:(); wi_fl:())
tg1:asc select EVENT_ID:"I" $ string EVENT_ID,SETTLED_DATE:string SETTLED_DATE,FULL_DESCRIPTION:string FULL_DESCRIPTION,SCHEDULED_OFF:string SCHEDULED_OFF,EVENT:string EVENT,SELECTION_ID:"I" $ string SELECTION_ID,SELECTION:string SELECTION,ODDS:"F" $ string ODDS,NUMBER_BETS:"H" $ string NUMBER_BETS,VOLUME_MATCHED:"F" $ string VOLUME_MATCHED,LATEST_TAKEN:string LATEST_TAKEN,FIRST_TAKEN:string FIRST_TAKEN,WIN_FLAG:"I" $ string WIN_FLAG from tg where SPORTS_ID=2,IN_PLAY=`IP
i:0;
z:count tg1;
do[z;                            se_da:tg1[i;`SETTLED_DATE];    se_da2:repldat[se_da];    
                                     sc_of:tg1[i;`SCHEDULED_OFF]; sc_of2:repldat[sc_of];       
                                      la_ta:tg1[i;`LATEST_TAKEN];      la_ta2:repldat[la_ta];    
                                       fi_ta:tg1[i;`FIRST_TAKEN];        fi_ta2:repldat[fi_ta]; 
                       ev_id:tg1[i;`EVENT_ID];                   fu_de:tg1[i;`FULL_DESCRIPTION]; 
                            ev:tg1[i;`EVENT];                         se_id:tg1[i;`SELECTION_ID];   
                            se:tg1[i;`SELECTION];                     od:tg1[i;`ODDS];   
                      nu_be:tg1[i;`NUMBER_BETS];        vo_ma:tg1[i;`VOLUME_MATCHED];   
                         wi_fl:tg1[i;`WIN_FLAG];              
                               `all_tennis_inplay1 insert (i;ev_id;se_da2;fu_de;sc_of2;ev;se_id;se;od;nu_be;vo_ma;la_ta2;fi_ta2;wi_fl) ;   
                                                             i+:1
    ];
save `:all_tennis_inplay1.txt
/=====================================================================================================================================================
Odds:asc select  ev_id,fu_de,se,fi_ta,se_id,od,vo_ma,wi_fl from all_tennis_inplay1 where (ev like "*Odds*")
save `:Odds.txt
/=====================================================================================================================================================
Set01:asc select  ev_id,fu_de,se,fi_ta,se_id,od,vo_ma,wi_fl from all_tennis_inplay1 where (ev like "*Set 01 Winner*") 
save `:Set01.txt
/=====================================================================================================================================================
Bet20:asc select  ev_id,fu_de,se,fi_ta,se_id,od,vo_ma,wi_fl from all_tennis_inplay1 where ((ev like "*Betting*") and (se like "*2 - 0*"))
save `:Bet20.txt
/=====================================================================================================================================================
Set02:asc select  ev_id,fu_de,se,fi_ta,se_id,od,vo_ma,wi_fl from all_tennis_inplay1 where (ev like "*Set 02 Winner*") 
save `:Set02.txt
/=====================================================================================================================================================
Odds_Set01:([] i:();    fu_de:();   se:(); od:();  vo_ma:();  fi_ta:(); odset1:(); odset2:();  odset3:())
i:0; z:count Odds; 
do[z;     fi_ta:Odds[i;`fi_ta];       my_ta1:fi_ta-2*0.00011574;  my_ta2:fi_ta-5*0.00011574;      fu_deodds:Odds[i;`fu_de];      se_idodds:Odds[i;`se_id];   
             se:Odds[i;`se];      s3:" " vs se;  c1:count s3; c1:c1-1; s4:"*",s3[c1],"*";           fu_deodds2:replfu[fu_deodds];    
             od:Odds[i;`od];            vo_ma:Odds[i;`vo_ma];            
             s1:select  from Set01 where (fu_de like fu_deodds) and (fi_ta>=my_ta2) and (fi_ta<=my_ta1) and (se_id=se_idodds);
             ii:0;  z2:count s1;  odset1:"";  wifl1:33; do[z2; sd:string s1[ii;`od];odset1:odset1,sd,"-"; ii+:1 ]; 
             s2:select  from Set02 where (fu_de like fu_deodds) and (fi_ta>=my_ta2) and (fi_ta<=my_ta1) and (se_id=se_idodds);
             ii:0;  z2:count s2;  odset2:"";  wifl2:2; do[z2; sd:string s2[ii;`od];odset2:odset2,sd,"+"; wifl2:s2[ii;`wi_fl]; ii+:1 ]; 
             s3:select  from Bet20 where (fu_de like fu_deodds) and (fi_ta>=my_ta2) and (fi_ta<=my_ta1) and (se like s4);
             ii:0;  z2:count s3;  odset3:"";  wifl3:2; do[z2; sd:string s3[ii;`od];odset3:odset3,sd,"="; wifl3:s3[ii;`wi_fl];  ii+:1 ]; 
            `Odds_Set01 insert (i;fu_deodds2;se;od;vo_ma;fi_ta;odset1;odset2;odset3) ;   
             i+:1
    ];
save `:Odds_Set01.txt
.z.P
/=====================================================================================================================================================