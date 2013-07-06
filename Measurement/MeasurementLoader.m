classdef MeasurementLoader
%this is the measurement loader class

    properties(SetAccess = private)
       sensorDataMap;
    end
   methods
       %Constructor
       function ML = MeasurementLoader(rawDataFolder,networkId,configId)
           %calls the function that loads data from files
           ML.sensorDataMap = newSensorDataSerializer(rawDataFolder,networkId,configId);
   
       end
       
       function numberOfSensors = getNumberOfSensors(ML)
       
           numberOfSensors = length(ML.sensorDataMap.keys);
       
       end
       
       function sensorIds = getSensorIds(ML)
          
           sensorIds=cell2mat(ML.sensorDataMap.keys);
           
       end
       
      function measurements = getMeasurements(ML,sensorId, startTime, endTime)
         %gets the measurements for given sensor and orders by time in
         %ascending order
          sensorData = ML.sensorDataMap(sensorId);
         
          timeStamps = cell2mat(sensorData.keys);
          
          %find the timestamps that match the query window
          timeStamps=timeStamps(timeStamps <= endTime & timeStamps >=startTime);
          
          timeStamps=sort(timeStamps,'ascend');
          
          numberOfMatchingTimeSteps=length(timeStamps);
          measurements=cell(numberOfMatchingTimeSteps,1);
          
          for timeStampIndex=1:numberOfMatchingTimeSteps
             
              measurements{timeStampIndex}=sensorData(timeStamps(timeStampIndex));
              
          end
          
         
      end


   end
end