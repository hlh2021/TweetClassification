package com.ibm.watson.developer_cloud.alchemy.v1;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class testTweet {
	

	 public static void main(String[] args)
	 {
		 AlchemyLanguage service = new AlchemyLanguage();
		 service.setApiKey("4e61cf65036c51f61a507de55f0a44efee8197b0");
		 
		 testAPI test = new testAPI();
		 //the files path to keep the entity and keyword information
		 String entityFilePath = "entities.txt";
		 String keywordFilePath = "keywords.txt";
		  
		    //read each tweet
		 	String originTweetFilePath = "c92.txt";
			File originTweetFile = new File(originTweetFilePath);
			FileReader fileReader = null;  
	        BufferedReader bufferedReader = null; 
	        try{
				fileReader = new FileReader(originTweetFile);  
	            bufferedReader = new BufferedReader(fileReader); 
		        String line = null;
		        while((line=bufferedReader.readLine())!=null)
		        { 
		        	//read each tweet
		        	String entityStr = "";
		        	String keywordStr = "";
		        	
		        	if(line.length()>=1)
		        	{
		        		ArrayList result = test.textTest(service, line);
		        		 //get the entities list
			       		 ArrayList entitiesList = (ArrayList)result.get(0);
			       		 for(int i=0; i<entitiesList.size(); i++)
			       		 {
			       			 ArrayList entity = (ArrayList)entitiesList.get(i);
			       			 String entityName = (String)entity.get(0);
			       			 Double entityRelev = (Double)entity.get(1);
			       			 //set the format to be "name, prob; "
			       			 entityStr = entityStr + entityName + ", " + String.valueOf(entityRelev) + "; ";
			       		 }
			       		 //remove last "; "
			       		 if(entityStr.length() > 0)
			       			 entityStr = entityStr.substring(0, entityStr.length()-2);  
			       		 //write the entity info into the file
			       		 test.writeFile(entityFilePath, entityStr);
			       		
			       		 //get the keywords list
			       		 ArrayList keywordsList = (ArrayList)result.get(1);
			       		 for(int j=0; j<keywordsList.size(); j++)
			       		 {
			       			 ArrayList keyword = (ArrayList)keywordsList.get(j);
			       			 String keywordName = (String)keyword.get(0);
			       			 Double keywordRelev = (Double)keyword.get(1);
			       			keywordStr = keywordStr + keywordName + ", " + String.valueOf(keywordRelev) + "; ";
			       		 }
			       		 if(keywordStr.length() > 0)
			       			 keywordStr = keywordStr.substring(0, keywordStr.length()-2);  
			       		 test.writeFile(keywordFilePath, keywordStr);
		        	}
		        }
	        }catch(Exception e){
				System.out.println("Fail to read the file!!!\n"+e);
			}finally { 
				System.out.println("End reading the file!!!");
	            try {  
	                if (bufferedReader != null) {  
	                    bufferedReader.close();  
	                }  
	                if (fileReader != null) {  
	                    fileReader.close();  
	                }  
	            } catch (IOException e) {  
	            	System.out.println("Fail to close reader!\n"+e);
	            }  
	        }  
		 
		 
	 }

}
