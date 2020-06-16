//ThreeEnvironments//

(
s.waitForBoot{
	fork{
		var nummics = 2;
		var g0 = Group.new; //first group
		var g1 = Group.after(g0); // sample group
		~t = 11; // time for cueing samples available in buffer, bufnum
		~ino = ArduinoSMS("/dev/tty.wchusbserial1420",9600); //Aduino communication to SC through Serial Port

		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

		//scheduling
		SystemClock.sched(0, {( ~t = 1).postln;nil }); //sec 1 - metal
		SystemClock.sched(30, {( ~t = 2).postln; nil }); //sec 2 - metal
		SystemClock.sched(60, {( ~t = 3).postln; nil });//sec 3 - war
		SystemClock.sched(90, {( ~t = 4).postln; nil }); // sec 4 - war
		SystemClock.sched(120, {( ~t = 5).postln; nil }); //sec 5 - synths
		SystemClock.sched(150, {( ~t = 6).postln; nil }); //sec 6 - synths
		SystemClock.sched(180, {( ~t = 0).postln; nil });// dead

		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


		//Buffer Dictionary z, contianing all the samples used in project so that they can be called into a synth using thier symbols rather than their buffer number
		z = Dictionary.new;
		PathName("/Users/edwardgoodwin/Desktop/PF-SoundFiles/").entries.do{
			arg subfolder;
			z.add(
				subfolder.folderName.asSymbol ->
				Array.fill(
					subfolder.entries.size,
					{
						arg i;
						Buffer.read(s,subfolder.entries[i].fullPath);
					}
				)
			);
		};


		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
		0.1.wait;
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

		//Arduino Action//
		~ino.action = {|msg|
			var msgsplit = split(msg,$:);
			var header = msgsplit[0].asSymbol;
			var val = msgsplit[1].asFloat;

	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


	////////////////
	//FSRs//\\\\\\\ - for controling pan of samples
	///////////////


			if(header==\fsr0,{
				s.sendMsg(\c_set, 0, val.linlin(50,350,-1,0)); // Sets FSRs value to be used as a control bus 0
				s.sendMsg(\n_map,4000, \pan, 0);
				s.sendMsg(\n_map,4100, \pan, 0);
				s.sendMsg(\n_map,4200, \pan, 0);
			},{
				if(header==\fsr1,{
					s.sendMsg(\c_set, 0, val.linlin(50,400,0,-0.4)); // Sets FSRs value to be used as a control bus 0
					s.sendMsg(\n_map,4300, \pan, 0);
					s.sendMsg(\n_map,4400, \pan, 0);
				},{
					if(header==\fsr3,{
						s.sendMsg(\c_set, 0, val.linlin(50,600,0,0.4)); // Sets FSRs value to be used as a control bus 0
						s.sendMsg(\n_map,4500, \pan, 0);
						s.sendMsg(\n_map,4600, \pan, 0);
						s.sendMsg(\n_map,4700, \pan, 0);

					},{
						if(header==\fsr2,{
							s.sendMsg(\c_set, 0, val.linlin(50,250,1,0.2)); // Sets FSRs value to be used as a control bus 0
							s.sendMsg(\n_map,4800, \pan, 0);
							s.sendMsg(\n_map,4900, \pan, 0);
						},{
						});//end if 4
					});//end if 4
				});//end if 3
			});//end if 2

	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


			/////////////////////
			//Butttons\\\\\\\\\\\ - for activating samples
			/////////////////////

			//Button0
			if( header == \b0, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4000,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[0,1,2,3].choose].bufnum, \amp, rrand(0.4,1), \pan, rrand(-1,-0.8), \rate, rrand(0.5,0.8));
					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4000,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[4,5,6,7].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-1,-0.8), \rate, rrand(0.4,1.4));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4000,0,g1.nodeID, \gate, 1,\bufnum, z[\Screams][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(-1,-0.8), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4000,0,g1.nodeID, \gate, 1,\bufnum, z[\Screams][[3,4,5,6,7,8].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(-1,-0.8), \rate, rrand(0.4,1.1));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4000,0,g1.nodeID, \gate, 1,\bufnum, z[\SynHigh][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-1,-0.8), \rate, rrand(0.6,1.2));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4000,0,g1.nodeID, \gate, 1,\bufnum, z[\SynHigh][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-1,-0.8), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton0

			//Button1
			if( header == \b1, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4100,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[0,1,2,3].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.8,-0.5), \rate, rrand(0.6,0.9));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4100,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[0,1,2,3].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.8,-0.5), \rate, rrand(0.4,1.4));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4100,0,g1.nodeID, \gate, 1,\bufnum, z[\MG][[5,6,7,8,9].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(-0.8,-0.5), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4100,0,g1.nodeID, \gate, 1,\bufnum, z[\MG][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(-0.8,-0.5), \rate, rrand(0.4,1.1));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4100,0,g1.nodeID, \gate, 1,\bufnum,z[\SynHigh][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(-0.8,-0.5), \rate, rrand(0.6,0.9));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4100,0,g1.nodeID, \gate, 1,\bufnum,z[\SynLow][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.8,-0.5), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton1

			//Button2
			if( header == \b2, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4200,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,0.9), \pan, rrand(-0.5,-0.1), \rate, rrand(0.6,0.9));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4200,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[5,6,7,8,9].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.5,-0.1), \rate, rrand(0.4,1.4));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4200,0,g1.nodeID, \gate, 1,\bufnum, z[\HandG][[4,5,6,7].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(-0.5,-0.1), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4200,0,g1.nodeID, \gate, 1,\bufnum, z[\Screams][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(-0.5,-0.1), \rate, rrand(0.6,0.9));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4200,0,g1.nodeID, \gate, 1,\bufnum, z[\SynthDown][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(-0.5,-0.5), \rate, rrand(0.4,1.1));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4200,0,g1.nodeID, \gate, 1,\bufnum, z[\SynthDown][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.5,-0.1), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton2


			//Button3
			if( header == \b3, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4300,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.5,1), \pan, rrand(-0.2,-0), \rate, rrand(0.6,0.9));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4300,0,g1.nodeID, \gate, 1,\bufnum,z[\WoodMetal][[5,6,7,8,9].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.2,-0), \rate, rrand(1,1.5));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4300,0,g1.nodeID, \gate, 1,\bufnum, z[\MG][[3,4,5].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(-0.2,-0), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4300,0,g1.nodeID, \gate, 1,\bufnum, z[\MG][[0,1,2].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(-0.2,-0), \rate, rrand(0.6,0.9));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4300,0,g1.nodeID, \gate, 1,\bufnum,z[\SynthDown][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(-0.2,-0), \rate, rrand(0.4,1.1));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4300,0,g1.nodeID, \gate, 1,\bufnum, z[\SynthDown][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.2,-0), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton3



			//Button4
			if( header == \b4, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4400,0,g1.nodeID, \gate, 1,\bufnum, z[\Klank][[0,1,2,3,4,5,6,7,8,9,10,11].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.1,0), \rate, rrand(0.6,1));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4400,0,g1.nodeID, \gate, 1,\bufnum, z[\Klink][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.1,0), \rate, rrand(1,1.9));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4400,0,g1.nodeID, \gate, 1,\bufnum, z[\WarSound][[0,1,2,3].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(-0.1,0), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4400,0,g1.nodeID, \gate, 1,\bufnum, z[\WarSound][[0,1,2,3].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(-0.1,0), \rate, rrand(0.6,0.9));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4400,0,g1.nodeID, \gate, 1,\bufnum, z[\SynChord][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(-0.1,0), \rate, rrand(0.4,1.1));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4400,0,g1.nodeID, \gate, 1,\bufnum, z[\SynChord][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(-0.2,-0), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton4




			//Button5
			if( header == \b5, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4500,0,g1.nodeID, \gate, 1,\bufnum, z[\Klink][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0, 0.1), \rate, rrand(0.6,1.5));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4500,0,g1.nodeID, \gate, 1,\bufnum, z[\Klank][[0,1,2,3,4,5,6,7,8,9,10,11].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0, 0.1), \rate, rrand(0.6,1.5));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4500,0,g1.nodeID, \gate, 1,\bufnum,z[\WarSound][[0,1,2,3].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(0, 0.1), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4500,0,g1.nodeID, \gate, 1,\bufnum, z[\WarSound][[0,1,2,3].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(0, 0.1), \rate, rrand(0.6,0.9));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4500,0,g1.nodeID, \gate, 1,\bufnum, z[\SynChord][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(0, 0.1), \rate, rrand(0.4,1.1));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4500,0,g1.nodeID, \gate, 1,\bufnum,z[\SynChord][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.7,1), \pan, rrand(0, 0.1), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton5

			//Button6
			if( header == \b6, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4600,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0, 0.2), \rate, rrand(0.8,1.2));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4600,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[5,6,7,8,9].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0, 0.2), \rate, rrand(1.0,1.3));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4600,0,g1.nodeID, \gate, 1,\bufnum, z[\HandG][[0,1,2,3].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(0, 0.2), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4600,0,g1.nodeID, \gate, 1,\bufnum, z[\HandG][[0,1,2,3].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(0, 0.2), \rate, rrand(0.6,0.9));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4600,0,g1.nodeID, \gate, 1,\bufnum, z[\SynChord][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(0, 0.2), \rate, rrand(0.4,1.1));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4600,0,g1.nodeID, \gate, 1,\bufnum, z[\SynChord][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.7,1), \pan, rrand(0, 0.2), \rate, rrand(0.9,1.2));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton6

			//Button7
			if( header == \b7, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4700,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.2, 0.5), \rate, rrand(0.6,0.9));
					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4700,0,g1.nodeID, \gate, 1,\bufnum, z[\WoodMetal][[5,6,7,8,9].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.2, 0.5), \rate, rrand(0.9,1.2));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4700,0,g1.nodeID, \gate, 1,\bufnum, z[\HandG][[4,5,6,7].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(0.2, 0.5), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4700,0,g1.nodeID, \gate, 1,\bufnum, z[\HandG][[0,1,3,7].choose].bufnum, \amp, rrand(0.1,0.5), \pan, rrand(0.2, 0.5), \rate, rrand(0.6,0.9));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4700,0,g1.nodeID, \gate, 1,\bufnum, z[\SynthDown][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(0.2, 0.5), \rate, rrand(0.4,1.1));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4700,0,g1.nodeID, \gate, 1,\bufnum, z[\SynthDown][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.7,1), \pan, rrand(0.2, 0.5), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton7

			//Button8
			if( header == \b8, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4800,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[0,1,2,3].choose].bufnum, \amp, rrand(0.7,1.2), \pan, rrand(0.5, 0.8), \rate, rrand(0.6,0.9));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4800,0,g1.nodeID, \gate, 1,\bufnum,z[\LowThuds][[4,5,6,7].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.5, 0.8), \rate, rrand(0.9,1.4));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4800,0,g1.nodeID, \gate, 1,\bufnum, z[\MG][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(0.5, 0.8), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4800,0,g1.nodeID, \gate, 1,\bufnum, z[\MG][[5,6,7,8,9].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(0.5, 0.8), \rate, rrand(0.4,1.1));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4800,0,g1.nodeID, \gate, 1,\bufnum, z[\SynHigh][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.5, 0.8), \rate, rrand(1,1.9));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4800,0,g1.nodeID, \gate, 1,\bufnum, z[\SynLow][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.5, 0.8), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton8

			//Button9
			if( header == \b9, {

				if(val == 1 && ~t == 1,{
					s.sendMsg(\s_new,\Samplet1,4900,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[0,1,2,3].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.8, 1), \rate, rrand(0.8,1));

					//end of synth1
				},{
					if(val==1 && ~t==2,{
						s.sendMsg(\s_new,\Samplet1,4900,0,g1.nodeID, \gate, 1,\bufnum, z[\LowThuds][[4,5,6,7].choose].bufnum, \amp, rrand(0.3,0.8), \pan, rrand(0.8, 1), \rate, rrand(1.2,1.4));
						//end of synth2
					},{
						if(val==1 && ~t==3,{
							s.sendMsg(\s_new,\Samplet1,4900,0,g1.nodeID, \gate, 1,\bufnum,  z[\Screams][[0,1,2,3,4,5].choose].bufnum, \amp, rrand(0.3,0.6), \pan, rrand(0.8, 1), \rate, rrand(0.6,1.4));
							//end of synth3
						},{
							if(val==1 && ~t==4,{
								s.sendMsg(\s_new,\Samplet1,4900,0,g1.nodeID, \gate, 1,\bufnum,  z[\Screams][[3,4,5,6,7,8].choose].bufnum, \amp, rrand(0.6,1), \pan, rrand(0.8, 1), \rate, rrand(0.4,1.1));
								//end of synth4
							},{
								if(val==1 && ~t==5,{
									s.sendMsg(\s_new,\Samplet1,4900,0,g1.nodeID, \gate, 1,\bufnum, z[\SynHigh][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.5, 0.8), \rate, rrand(0.7,1.2));
									//end of synth5
								},{
									if(val==1 && ~t==6,{
										s.sendMsg(\s_new,\Samplet1,4900,0,g1.nodeID, \gate, 1,\bufnum, z[\SynHigh][[0,1,2,3,4].choose].bufnum, \amp, rrand(0.3,1), \pan, rrand(0.8, 1), \rate, rrand(0.6,0.9));
										//end of synth6
									},{

									});//seventh
								});//sixth
							});//fifth
						});//fourth if close
					});//third if close
				} );//second if close
			} ); //first if close
			//EndButton9


		};//end of InoAction


		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

		/////////////////////
		/////SYNTH DEFS/////
		/////////////////////

		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

		//Samplet1
		SynthDef(\Samplet1, {
			arg ich = 0, obs = 0, gate = 0, bufnum = 0, pan = 0, amp = 1, rate = 1, lpfreq = 20000, hpfreq = 0,spos = 0;
			var source, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.8), gate);
			source = PlayBuf.ar(2, bufnum, rate*BufRateScale.ir(bufnum),startPos:spos, doneAction:2, ); //plays
			source = Balance2.ar(source[0],source[1], pan, amp);
			source = LPF.ar(source,lpfreq);
			source = HPF.ar(source,hpfreq);
			Out.ar(obs,source*env);
		} ).add;

		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


		0.1.wait;

		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


	} //end fork
} //end s.waitForBoot
)