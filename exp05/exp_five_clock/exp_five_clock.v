module exp_five_clock(alarmlight,set_alarm,alarm_on,stopwatch,clearstopwatch,adjh,adjm,adjs,keyh_n,keym_n,keys_n,clk,stop,seg0h,seg1h,seg1m,seg0m,seg1s,seg0s);
	input clk;
	input stop;
	input adjh,adjm,adjs,keyh_n,keym_n,keys_n;
	input stopwatch,set_alarm,alarm_on;
	input clearstopwatch;
	reg[16:0] total,stoptotal,alarmtotal;
	reg clk_1s;
	reg[24:0]count_clk;
	reg[5:0] hour;
	reg[5:0] minute;
	reg[5:0] second;
	reg[3:0]hh,lh,hm,lm,hs,ls;
	output reg [6:0] seg0h,seg1h,seg1m,seg0m,seg1s,seg0s;
	reg flag;
	output reg alarmlight;
	
initial
	begin
	total=0;
	stoptotal=0;
	alarmtotal=0;
	hour=0;
	minute=0;
	second=0;
	count_clk=0;
	clk_1s=0;
	flag=0;
	end
	
	always@(posedge clk)
	if(count_clk==25000000)
		begin
			count_clk<=0;
			clk_1s<=~clk_1s;
		end
	else
		count_clk<=count_clk+1;
	
	always@(posedge clk_1s)
	begin
		if((!stopwatch)&&(!set_alarm))//如果没有进行秒表的功能，也没有进行闹钟的设置，就正常显示时间
		begin//***************************************************以下为正常时钟功能
			flag=~flag;//便于闪烁
			if(stop)		//砸瓦鲁多!!时间停止!!
				begin
				hour=hour;
				minute=minute;
				second=second;
				total=total;
				
				hh=hour/10;
				lh=hour%10;
				hm=minute/10;
				lm=minute%10;
				hs=second/10;
				ls=second%10;
				end
			else if(adjh)//调整小时
				begin
					if(keyh_n)
						begin
						hour=hour;
						minute=minute;
						second=second;
						total=total;
						end
					else
						begin
						total=(total+3600)%86400;
						hour=total/3600;
						minute=(total%3600)/60;
						second=total%60;
						end
					
					if(flag)//小时数码管的闪烁处理
						begin
						hh=10;
						lh=10;
						
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
					else
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
				end
			else if(adjm)//调整分钟
				begin
					if(keym_n)
						begin
						hour=hour;
						minute=minute;
						second=second;
						total=total;
						end
					else
						begin
						total=(total+60)%86400;
						hour=total/3600;
						minute=(total%3600)/60;
						second=total%60;
						end
					
					if(flag)//分钟数码管的闪烁处理
						begin
						hh=hour/10;
						lh=hour%10;
						
						hm=10;
						lm=10;
						
						hs=second/10;
						ls=second%10;
						end
					else
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
				end
			else if(adjs)//调整秒钟
				begin
					if(keys_n)
						begin
						hour=hour;
						minute=minute;
						second=second;
						total=total;
						end
					else
						begin
						total=(total+1)%86400;
						hour=total/3600;
						minute=(total%3600)/60;
						second=total%60;
						end
					
					if(flag)//秒钟数码管的闪烁处理
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						
						hs=10;
						ls=10;
						end
					else
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
				end
			else
				begin		//时间正常流淌！！
				total=(total+1)%86400;
				hour=total/3600;
				minute=(total%3600)/60;
				second=total%60;
				
				hh=hour/10;
				lh=hour%10;
				hm=minute/10;
				lm=minute%10;
				hs=second/10;
				ls=second%10;
				
				//检查闹钟时间到没到
				if(alarm_on && (total==alarmtotal))
				alarmlight=1;
				else
				alarmlight=0;
				
				end
		end//*************************************************************以上为正常的时钟功能
		else if(stopwatch)//如果stopwatch功能打开了
		begin//************************************************************以下为秒表功能
		
				if(clearstopwatch)
				begin
				total=(total+1)%86400;//时间正常计算，不影响时钟的正常运作，只是不显示
				stoptotal=0;
				hour=stoptotal/3600;
				minute=(stoptotal%3600)/60;
				second=stoptotal%60;
				
				hh=hour/10;
				lh=hour%10;
				hm=minute/10;
				lm=minute%10;
				hs=second/10;
				ls=second%10;
				end
				else if(stop)
				begin
				hour=hour;
				minute=minute;
				second=second;
				stoptotal=stoptotal;
				total=(total+1)%86400;//时间正常计算，不影响时钟的正常运作，只是不显示
				
				hh=hour/10;
				lh=hour%10;
				hm=minute/10;
				lm=minute%10;
				hs=second/10;
				ls=second%10;
				end
				else
				begin
				total=(total+1)%86400;//时间正常计算，不影响时钟的正常运作，只是不显示
				stoptotal=(stoptotal+1)%86400;
				hour=stoptotal/3600;
				minute=(stoptotal%3600)/60;
				second=stoptotal%60;
				
				hh=hour/10;
				lh=hour%10;
				hm=minute/10;
				lm=minute%10;
				hs=second/10;
				ls=second%10;
				end
		end//**************************************************************以上为秒表功能
		else//stopwatch没打开，那就是set_alarm打开了
		begin//********************************************************以下为设置闹钟的功能
		flag=~flag;//便于闪烁
		total=(total+1)%86400;//时间正常计算，不影响时钟的正常运作，只是不显示
		
		hour=alarmtotal/3600;//把时分秒初始化为闹钟设置时间，不然数码管一开始会接着显示时间
		minute=(alarmtotal%3600)/60;
		second=alarmtotal%60;
		
			if(adjh)
				begin
					if(keyh_n)
						begin
						hour=hour;
						minute=minute;
						second=second;
						alarmtotal=alarmtotal;
						end
					else
						begin
						alarmtotal=(alarmtotal+3600)%86400;
						hour=alarmtotal/3600;
						minute=(alarmtotal%3600)/60;
						second=alarmtotal%60;
						end
					
					if(flag)
						begin
						hh=10;
						lh=10;
						
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
					else
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
				end
			else if(adjm)
				begin
					if(keym_n)
						begin
						hour=hour;
						minute=minute;
						second=second;
						alarmtotal=alarmtotal;
						end
					else
						begin
						alarmtotal=(alarmtotal+60)%86400;
						hour=alarmtotal/3600;
						minute=(alarmtotal%3600)/60;
						second=alarmtotal%60;
						end
					
					if(flag)
						begin
						hh=hour/10;
						lh=hour%10;
						
						hm=10;
						lm=10;
						
						hs=second/10;
						ls=second%10;
						end
					else
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
				end
			else if(adjs)
				begin
					if(keys_n)
						begin
						hour=hour;
						minute=minute;
						second=second;
						alarmtotal=alarmtotal;
						end
					else
						begin
						alarmtotal=(alarmtotal+1)%86400;
						hour=alarmtotal/3600;
						minute=(alarmtotal%3600)/60;
						second=alarmtotal%60;
						end
					
					if(flag)
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						
						hs=10;
						ls=10;
						end
					else
						begin
						hh=hour/10;
						lh=hour%10;
						hm=minute/10;
						lm=minute%10;
						hs=second/10;
						ls=second%10;
						end
				end
			else
			begin
				hour=hour;
				minute=minute;
				second=second;
				alarmtotal=alarmtotal;

				if(flag)//设置闹钟时全体闪烁处理
					begin
					hh=10;
					lh=10;
					hm=10;
					lm=10;
					hs=10;
					ls=10;
					end
				else
					begin
					hh=hour/10;
					lh=hour%10;
					hm=minute/10;
					lm=minute%10;
					hs=second/10;
					ls=second%10;
					end

			end
		
		end//************************************************************以上为设置闹钟的功能
		
		//以下处理电子管的显数
			case(hh)
				0: seg1h = 7'b1000000;
				1: seg1h = 7'b1111001;
				2: seg1h = 7'b0100100;
				3: seg1h = 7'b0110000;
				4: seg1h = 7'b0011001;
				5: seg1h = 7'b0010010;
				6: seg1h = 7'b0000010;
				7: seg1h = 7'b1111000;
				8: seg1h = 7'b0000000;
				9: seg1h = 7'b0010000;
				10:seg1h = 7'b1111111;
			endcase
			
			case(lh)
				0: seg0h = 7'b1000000;
				1: seg0h = 7'b1111001;
				2: seg0h = 7'b0100100;
				3: seg0h = 7'b0110000;
				4: seg0h = 7'b0011001;
				5: seg0h = 7'b0010010;
				6: seg0h = 7'b0000010;
				7: seg0h = 7'b1111000;
				8: seg0h = 7'b0000000;
				9: seg0h = 7'b0010000;
				10:seg0h = 7'b1111111;
			endcase
			
			
			case(hm)
				0: seg1m = 7'b1000000;
				1: seg1m = 7'b1111001;
				2: seg1m = 7'b0100100;
				3: seg1m = 7'b0110000;
				4: seg1m = 7'b0011001;
				5: seg1m = 7'b0010010;
				6: seg1m = 7'b0000010;
				7: seg1m = 7'b1111000;
				8: seg1m = 7'b0000000;
				9: seg1m = 7'b0010000;
				10:seg1m = 7'b1111111;
			endcase
			
			case(lm)
				0: seg0m = 7'b1000000;
				1: seg0m = 7'b1111001;
				2: seg0m = 7'b0100100;
				3: seg0m = 7'b0110000;
				4: seg0m = 7'b0011001;
				5: seg0m = 7'b0010010;
				6: seg0m = 7'b0000010;
				7: seg0m = 7'b1111000;
				8: seg0m = 7'b0000000;
				9: seg0m = 7'b0010000;
				10:seg0m = 7'b1111111;
			endcase
			
			
			case(hs)
				0: seg1s = 7'b1000000;
				1: seg1s = 7'b1111001;
				2: seg1s = 7'b0100100;
				3: seg1s = 7'b0110000;
				4: seg1s = 7'b0011001;
				5: seg1s = 7'b0010010;
				6: seg1s = 7'b0000010;
				7: seg1s = 7'b1111000;
				8: seg1s = 7'b0000000;
				9: seg1s = 7'b0010000;
				10:seg1s = 7'b1111111;
			endcase
			
			case(ls)
				0: seg0s = 7'b1000000;
				1: seg0s = 7'b1111001;
				2: seg0s = 7'b0100100;
				3: seg0s = 7'b0110000;
				4: seg0s = 7'b0011001;
				5: seg0s = 7'b0010010;
				6: seg0s = 7'b0000010;
				7: seg0s = 7'b1111000;
				8: seg0s = 7'b0000000;
				9: seg0s = 7'b0010000;
				10:seg0s = 7'b1111111;
			endcase
	end
	
endmodule 
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		