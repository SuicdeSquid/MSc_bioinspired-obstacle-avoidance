classdef EMD
    %Class for an Elementary Motion Detector (EMD), specifically Reichardt detector, as found in some insects
    %brains.
    %The input is a video split into frames. Rout gives the total output
    %of excitory - inhibitory response, biassed toward the camera moving
    %in the direction that Ag implies
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
        PlottingInfo  %Information for plotting results
        
    end
    
    methods
        function obj = preparePlot(obj,f)
            %creates title and axis labels for plot
            obj.PlottingInfo.title = "Output of " + num2str((obj.Number(1)*obj.Number(2))) + " EMDs, with: Tau = " ...
                + num2str(obj.Tau) + ", Spatial Sampling Distance = " + num2str(obj.Lambda)...
                + ", at angle = " + num2str(obj.Angle) + "deg anti-clkwise from x-axis";
            obj.PlottingInfo.titleshort = "Tau = " + num2str(obj.Tau) + ", Ag = " + num2str(obj.Lambda);
            obj.PlottingInfo.xlabel = "Number of frames (at " + num2str(f.fps) + " fps)";
            obj.PlottingInfo.ylabel = 'Relative Units';
            
        end
        function obj = prepareForData(obj,f)
            %Creates appropriate arrays of zero in preparation to speed up
            %processing time. Also creates indexing array of ones and zeros
            %to set position of EMDs

            obj.S1Edash = zeros(obj.Number(1),obj.Number(2),f.T);
            obj.S1Idash = zeros(obj.Number(1),obj.Number(2),f.T);
          
            obj.Pos.l1 = zeros(f.H,f.W,f.T);
            obj.Pos.l2 = zeros(f.H,f.W,f.T);
            
            if not(obj.Pos.exist)
                stridedown = floor((f.H-obj.Ag(1)-1)/obj.Number(1));
                stridealong = floor((f.W-abs(obj.Ag(2))-1)/obj.Number(2));
                if obj.Ag(2) < 0
                    disp("Only Ag(1) can be negative. If you need the response going the other way, have a positive Ag(2) and multiply the result by -1")
                    quit
                end
                
                obj.Pos.Y = 1:stridealong:stridealong*obj.Number(2);
                
                if obj.Ag(1) >= 0
                    obj.Pos.X = 1:stridedown:stridedown*obj.Number(1);
                else
                    obj.Pos.X = 1+abs(obj.Ag(1)):stridedown:abs(obj.Ag(1))+stridedown*obj.Number(1);
                end
                
                obj.Pos.l1(obj.Pos.X,obj.Pos.Y,:) = 1;
                obj.Pos.l2(obj.Pos.X+obj.Ag(1),obj.Pos.Y+obj.Ag(2),:) = 1;
                
            end
            
        end
        function obj = fillData(obj,f)
            %Takes data from frames of a video and puts them into the EMD array. allows for the programmer to
            %select the number of EMDs in the array they would like.
            
            obj.S1E = double(f.frames(obj.Pos.X,obj.Pos.Y,:));
            obj.S1E(:, all(~obj.S1E,[1,3]),:) = [];         %removes columns of zeros
            obj.S1E(all(~obj.S1E,[2,3]),:,:) = [];              %removes rows of zeros
            obj.S2I = obj.S1E;
            
            obj.S1I = double(f.frames(obj.Pos.X+obj.Ag(1),obj.Pos.Y+obj.Ag(2),:));
            obj.S1I(:, all(~obj.S1I,[1,3]),:) = [];            %removes columns of zeros
            obj.S1I(all(~obj.S1I,[2,3]),:,:) = [];                 %removes rows of zeros
            obj.S2E = obj.S1I;
           
        end
        function obj = lowPassFilter(obj,f)
            %Low pass filters the excitory and inhibitory responses into chanel 1
            for t = 1:f.T-1
                %Low pass filter
                obj.S1Edash(:,:,t+1) = (obj.S1E(:,:,t) - obj.S1Edash(:,:,t))/obj.Tau + obj.S1Edash(:,:,t);
                obj.S1Idash(:,:,t+1) = (obj.S1I(:,:,t) - obj.S1Idash(:,:,t))/obj.Tau + obj.S1Idash(:,:,t);
            end
        end
        function obj = EMD(Tau, Ag, Number, Coord)
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
        function obj = computeResults(obj)
            %Does EMD calculations to get results
            obj.Rexcite = obj.S1Edash.*obj.S2E;
            obj.Rinhibit = obj.S1Idash.*obj.S2I;
            
            obj.Rout = squeeze(mean(obj.Rinhibit-obj.Rexcite,[1 2]));
        end
        
        function obj = showFrame(obj,framenumber)
            %Present the calculation result of each frame
            obj.Rexcite = obj.S1Edash.*obj.S2E;
            obj.Rinhibit = obj.S1Idash.*obj.S2I;
            
            obj.RoutSingleFrame = obj.Rinhibit(:,:,framenumber)-obj.Rexcite(:,:,framenumber);
        end
            
        function plotPositions(obj, sameplot)
            %Function to plot location of the EMDs. Multiple EMDs can be plotted
            %on one figure by setting sameplot = 'on', or a new figure can
            %be made each time by setting it to 'off'
            
            if strcmp('off',sameplot)
                figure
            end
            
            X = zeros(obj.Number(1)*obj.Number(2),1);
            Y = zeros(obj.Number(1)*obj.Number(2),1);
            
            for i = 0:obj.Number(2)-1
                Y(i*(obj.Number(1)-1)+1+i:(i+1)*(obj.Number(1)-1) + i + 1) = obj.Pos.X; 
            end
            
            for i = 0:obj.Number(2)-1
                X(i*(obj.Number(1)-1)+1+i:(i+1)*(obj.Number(1)-1) + i + 1) = ones(obj.Number(1),1)*obj.Pos.Y(i+1);
            end
            
            quiver(X,Y,ones(obj.Number(1)*obj.Number(2),1).*obj.Ag(2),ones(obj.Number(1)*obj.Number(2),1).*obj.Ag(1))        
            
            
            if strcmp('on',sameplot)
                hold on
            elseif strcmp('off',sameplot)
                hold off
            end
            
        end
        function obj = reduceMemory(obj)
            %Function to remove intermediate values from memory, only keeps
            %overall average response, and plotting information about the
            %EMD parameters
            obj.S1E = [];
            obj.S1I = [];
            obj.S2E = [];
            obj.S2I = [];
            obj.S1Edash = [];
            obj.S1Idash = [];
            obj.Rexcite= []; 
            obj.Rinhibit= [];
            obj.Pos = [];
        end
    end
end




