result=webread('https://data.humdata.org/hxlproxy/api/data-preview.csv?url=https%3A%2F%2Fraw.githubusercontent.com%2FCSSEGISandData%2FCOVID-19%2Fmaster%2Fcsse_covid_19_data%2Fcsse_covid_19_time_series%2Ftime_series_covid19_confirmed_global.csv&filename=time_series_covid19_confirmed_global.csv','options','table');
result1=result(1,:);
result(1,:)=[];
result=sortrows(result,2);
result=[result1;result]
shape1=size(result);
country={'China','Italy','US','Germany','United Kingdom','India','Spain','Iran','Korea, South','France','Bangladesh','Pakistan','Qatar','Japan'};
countrynum=length(country);
state=0;
for n=1:countrynum
    for i=2:shape1(1,1)
        if state==0
            if country(n)==string(table2array(result(i,2)))
                country1=i;
                dummy1=i;
                state=state+1;
            end
        else
            if country(n)==string(table2array(result(i,2)))
                dummy2=i;
                state=state+1;
            end
        end
    end
    if state>1
        for m=5:shape1(1,2)-4
            dummy3=char(string(sum(str2double(table2array(result(dummy1:dummy2,m))))));
            result(dummy1,m)={dummy3};
        end
    end
    date=-1;
    increment=6;
    loopcount=floor((shape1(1,2)-4)/6);
    for i=1:loopcount
        date=date+increment;
        newcasesinaweek=str2double(table2array(result(country1,date:date+increment)));
        totalcasesinaweek(1,i)=sum(newcasesinaweek);
        averagenewcasesinaweek(1,i)=sum(newcasesinaweek)/7;
    end
    length2=length(totalcasesinaweek);
    for i=1:length2-1
        dummy4=totalcasesinaweek(i)+totalcasesinaweek(i+1);
        totalcasesinaweek(i+1)=dummy4;
    end
    if n==1
      period=date+increment;
      figure('Position',[0 0 1920 1080])  
    end
    loglog(totalcasesinaweek,averagenewcasesinaweek,'linewidth',3)
    indicator1=country{n};
    indicator2='\leftarrow ';
    indicator=append(indicator2,indicator1);
    text(totalcasesinaweek(loopcount),averagenewcasesinaweek(loopcount),indicator,'FontSize',12)
    hold on
    state=0;
end
title('COVID 19 Country Analysis in log scale','FontSize', 24)
xlabel('Total Cases','FontSize', 20)
ylabel('Average New Cases','FontSize', 20)
timeindicator1=table2array(result(1,period));
timeindicator2='Last Updated: ';
timeindicator=append(timeindicator2,timeindicator1);
text(10^2,10^4,timeindicator,'FontSize',15)
legend(country,'Location',"best")