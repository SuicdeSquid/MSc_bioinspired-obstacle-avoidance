classdef FlowofFlow
    % Class for flow of flow calculation
    % The input is the EMD computed output result
    
    properties
        
         %Input parameters
        Number      %Number of EMDs you want in the array
        Ag              %Number of pixels between sampling points (spacial sampling base mimics ommatidia angle in insect vision)
        Lambda      %Euclidean distance (pixels) Ag(1) Ag(2)
        Angle           %Angle anticlockwise from x-axis that preferred direction of detector is in
        Tau             %Time constant in the low pass filter
        Pos             %Position structure, containing information about the position of where you want the EMDs in the array (if not defined at the beginning it spaces them evenly acros the image)
        framenumber % Number of frame you want to choose
        
        %Calculation variables
        S1E            %Chanel 1 excitory response
        S1I             %Chanel 1 inhibitory response
        S2E             %Chanel 2 excitory response
        S2I             %Chanel 2 inhibitory response
        S1Edash     %Chanel 1 excitory low pass filtered
        S1Idash     %Chanel 2 inhibitory low pass filtered
        Rexcite         %Total Excitation
        Rinhibit        %Total Inhibition
        Rout            %Averaged output of EMD 
        RoutSingleFrame %Single frame output
    end
    
    methods
        
        function obj = FlowofFlow(Tau, Ag, Number, Coord)
            %Creates EMD array of size given by 'Number'. Where each individual Reichardt detector is parameterised by time constant in low-pass filter (tau) and spatial sampling base (Ag)
            
            obj.Tau = Tau;
            obj.Ag = Ag;
            obj.Number = Number;
            obj.Lambda = round(sqrt(obj.Ag(1)^2+obj.Ag(2)^2),2);
            obj.Angle = round(rad2deg(atan(-obj.Ag(1)/obj.Ag(2))),2);
            obj.Pos.exist = exist('Coord');
            
            if obj.Pos.exist
                obj.Pos.Coord = Coord;
            end
            
        end
        
        
        function obj = prepareForData(obj,framefof)
            %Creates appropriate arrays of zero in preparation to speed up
            %processing time. Also creates indexing array of ones and zeros
            %to set position of EMDs

            obj.S1Edash = zeros(obj.Number(1),obj.Number(2),framefof.T);
            obj.S1Idash = zeros(obj.Number(1),obj.Number(2),framefof.T);
            
            obj.Pos.l1 = zeros(250,framefof.Length);
            obj.Pos.l2 = zeros(250,framefof.Length);
          
            if not(obj.Pos.exist)
                
                %stridedown = floor((f.H-obj.Ag(1)-1)/obj.Number(1));
                stridealong = floor((framefof.Length-abs(obj.Ag(2))-1)/obj.Number(2));
                
                if obj.Ag(2) < 0
                    disp("Only Ag(1) can be negative. If you need the response going the other way, have a positive Ag(2) and multiply the result by -1")
                    quit
                end
                
                obj.Pos.Y = 1:1:obj.Number(2);
                
            end
            
        end
        
        function obj = fillData(obj,framefof)
            %Takes data from frames of a video and puts them into the EMD array. allows for the programmer to
            %select the number of EMDs in the array they would like.
            for t = 1:framefof.T
                obj.S1E(:,:,t) = framefof.Complete_frame_EMD(t,:);
                obj.S1I(:,:,t) = framefof.Complete_frame_EMD(t,:);
                
            end
           
           
        end
%         
        function obj = lowPassFilter(obj,framefof)
            %Low pass filters the excitory and inhibitory responses into chanel 1
            for t = 1:framefof.T-1
                %Low pass filter
                obj.S1Edash(:,:,t+1) = (framefof.Complete_frame_EMD(t,:) - obj.S1Edash(:,:,t))/obj.Tau + obj.S1Edash(:,:,t);
                obj.S1Idash(:,:,t+1) = (framefof.Complete_frame_EMD(t,:) - obj.S1Idash(:,:,t))/obj.Tau + obj.S1Idash(:,:,t);
            end
        end
        
%         function obj = computeResults(obj)
%             %Does EMD calculations to get results
%             obj.Rexcite = obj.S1Edash.*obj.S2E;
%             obj.Rinhibit = obj.S1Idash.*obj.S2I;
%             
%             obj.Rout = squeeze(mean(obj.Rinhibit-obj.Rexcite,[1 2]));
%         end
        
        function obj = showFrame(obj,framefof,framenumber)
            %Present the calculation result of each frame
            for i = 1:framefof.T
                for j = 1:framefof.Length-1
                    obj.Rexcite(i,j) = obj.S1Edash(:,j+1,i)*framefof.Complete_frame_EMD(i,j);
                    obj.Rinhibit(i,j) = obj.S1Idash(:,j,i)*framefof.Complete_frame_EMD(i,j+1);
                end
            end
            obj.RoutSingleFrame = obj.Rinhibit(framenumber,:)-obj.Rexcite(framenumber,:);
        end
        
    end
    
        
end
