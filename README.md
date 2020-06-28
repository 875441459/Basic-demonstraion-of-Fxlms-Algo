# Basic-demonstraion-of-Fxlms-Algo
Containing the basic Fxlms Algo for Broadband and narrowband active noise control(ANC)
# Broadband ANC
Fxlms_test.m-->test the Fxlms Algo in different setting(such as the modeling error,the secondary path)
Fxlms_v1.m-->basic Fxlms Algorithm for broadband ANC(it can control pure tone noise too, but with more calculating complexity, for pure tone noise control,we often use Narrowband ANC introduced in below) 
pinknoise.m-->generate the pinke noise, the original m files is coded by Hristo Zhivomirov https://www.mathworks.com/matlabcentral/fileexchange/42919-pink-red-blue-and-violet-noise-generation-with-matlab
Mul_Fxlms.m-->Multichannel Fxlms(I reference microphone(I=1 here),J secondary source(actuator/loudspeaker), K error microphone)
# Narrowband ANC
