package com.ibm.watson.developer_cloud.alchemy.v1;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.ibm.watson.developer_cloud.alchemy.v1.model.DocumentSentiment;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Entities;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Entity;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Keyword;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Keywords;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Sentiment;


public class testAPI {
	
	/*** find all entities and keywords in this tweet *****/
	public ArrayList textTest(AlchemyLanguage service, String tweet)
	{
		ArrayList resList = new ArrayList();
		ArrayList entitiesList = new ArrayList();
		ArrayList keywordsList = new ArrayList();
		
		  Map<String,Object> params = new HashMap<String, Object>();
		  params.put(AlchemyLanguage.TEXT, tweet);
		  
		  //get the entities list
		  try{
			  Entities entities = service.getEntities(params);
			  int size1 = entities.getEntities().size();
			  System.out.println("\nThere are "+size1+" entities in this text");
			  //show entities if have
			  int top1 = size1 > 5 ? 5 : size1;
			  for(int i=1; i<=size1; i++)
			  {
				  Entity entity = entities.getEntities().get(i-1);
				  String value1 = entity.getText();
				  Double relevance1 = entity.getRelevance();	
				  //add the entity and probability to entitiesList
				  ArrayList entityObject = new ArrayList();
				  entityObject.add(value1);
				  entityObject.add(relevance1);
				  entitiesList.add(entityObject);
				  
				  System.out.println("The "+i+"-th entity is "+value1+" , with relevance "+relevance1);
//				  System.out.println("entity: "+entity);
//				  Sentiment sentiment = entity.getSentiment();
			  }
			  
			  //get the keywords
			  Keywords keywords = service.getKeywords(params);
			  int size2 = keywords.getKeywords().size();
			  System.out.println("There are "+size2+" keywords in this text");
			  //show keywords if have
			  int top2 = size2 > 5 ? 5 : size2;
			  for(int i=1; i<=size2; i++)
			  {
				  Keyword keyword = keywords.getKeywords().get(i-1);
				  String value2 = keyword.getText();
				  Double relevance2 = keyword.getRelevance();	
				  //add the keyword and probability to keywordsList
				  ArrayList keywordObject = new ArrayList();
				  keywordObject.add(value2);
				  keywordObject.add(relevance2);
				  keywordsList.add(keywordObject);
				  
				  System.out.println("The "+i+"-th keyword is: "+value2+" , with relevance "+relevance2);
			  }
		  }catch(Exception e){
			  System.out.println(e);
		  }
		  
		  
		 /**
		  //get the sentiment
		  DocumentSentiment sentiment =  service.getSentiment(params);
		  System.out.println(sentiment);
		**/
		  resList.add(entitiesList);
		  resList.add(keywordsList);
		 
		  return resList;
	}
	
	
	/**** find all entities in the string ****/
	public ArrayList<String[]> findEntities(AlchemyLanguage service, String str)
	{
		ArrayList<String[]> result = new ArrayList<String[]>();
		
		Map<String,Object> params = new HashMap<String, Object>();
		params.put(AlchemyLanguage.TEXT, str);
		try{
			Entities entities = service.getEntities(params); 
			int size1 = entities.getEntities().size();
			System.out.println("\nThere are "+size1+" entities in this text");
			for(int i=1; i<=size1; i++)
			{
				Entity entity = entities.getEntities().get(i-1);
				String value1 = entity.getText();
				Double relevance1 = entity.getRelevance();
				//add the entity and probability to entitiesList
				String[] entityArray = new String[2];
				entityArray[0] = value1;
				entityArray[1] = String.valueOf(relevance1);
				result.add(entityArray);
			}
			
		}catch(Exception e){
			  System.out.println(e);
		}		
		
		return result;
	}
	

	/**** find all keywords in the string ****/
	public ArrayList<String[]> findKeywords(AlchemyLanguage service, String str)
	{
		ArrayList<String[]> result = new ArrayList<String[]>();
		
		Map<String,Object> params = new HashMap<String, Object>();
		params.put(AlchemyLanguage.TEXT, str);
		try{
			Keywords keywords = service.getKeywords(params); 
			int size1 = keywords.getKeywords().size();
			System.out.println("\nThere are "+size1+" keywords in this text");
			for(int i=1; i<=size1; i++)
			{
				Keyword keyword = keywords.getKeywords().get(i-1);
				String value1 = keyword.getText();
				Double relevance1 = keyword.getRelevance();
				//add the keyword and probability to list
				String[] keywordArray = new String[2];
				keywordArray[0] = value1;
				keywordArray[1] = String.valueOf(relevance1);
				result.add(keywordArray);
			}
			
		}catch(Exception e){
			  System.out.println(e);
		}		
		
		return result;
	}
	
	
	/**** write a new line at the end of the file ****/
	public void writeFile(String filePath, String text)
	{
		try{
			BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true));
			bw.write(text);
			bw.newLine();
			bw.flush();
			bw.close();
		}catch(Exception e){
			System.out.println("Error in writing: " + text);
		}	
	}
	
	
	
	
	public static void main(String[] args)
	 {
		 AlchemyLanguage service = new AlchemyLanguage();
		 service.setApiKey("545338457a8c0d3a6265b1b062644d1bab793ba4");
		 
		 String text = "There’s an old sea story about a ship’s Captain who inspected his sailors, and afterward told the first mate that his men smelled bad.  The Captain suggested perhaps it would help if the sailors would change underwear occasionally. The first mate responded, “Aye, aye sir, I’ll see to it immediately!”  The first mate went straight to the sailor’s berth and announced, “The Captain thinks you guys smell bad and wants you to change your underwear.”?  "
					+ "He continued, “Boehner you change with McConnell, McCain you change with Ryan, Corker you change with Paul and Graham you change with Cruz.   THE MORAL OF THE STORY:  Someone may come along and promise “Change” but don’t count on things smelling any better.  The Republican Party won the majority in the House and Senate in the last two elections based on lies.  Where have they been? Where is the leadership?  "
					+ "Where is the Republican Leadership Regarding The Following:  Obama’s Iran Nuclear Agreement Defunding tax support for Planned Parenthood Defunding Obamacare Reigning in the run away EPA Tuning in a balanced budget Trimming unless and bloated Government programs and departments  You would think that Democrats still controlled both the US House and Senate and Nancy Pelosi and Harry Reid were still in charge…..  "
					+ "Since the last elections, Boehner and McConnell have been nothing more than a joke!!  From Obamacare to executive amnesty to Obamatrade, immigration and the run away EPA regulations on energy the hierarchy and leaders of the Republican Party in the House and Senate have refused to represent the interests of Americans voters that elected them and put them in office.  "
					+ "Instead, they have supported, helped pass or let pass Obama’s and his left leaning minions agenda without so much as a ripple of opposition, or suggestions for better ideas.  Presently the leaders of the Republican Party as well as the Democrats are on the edge of giving Obama and his left leaning socialist minions a path to a Nuclear Bomb through a shrouded and cloudy Nuclear Treaty with Iran, the worlds largest country supporting and giving sanctuary to Radical Islamic Terrorists.  "
					+ "Conservatives will have an eye on the House and Senate leadership over the next months leading up to the next election….  Additionally, In case you haven’t noticed, Trump is now leading all the GOP candidates in recent and meaningful political polls.  If the present GOP candidates for POTUS don’t start representing the people that elected them, I fear that H. Clinton or B. Sanders will win in 2016…..? "
					+ "I really don't have much respect for Hillary Clinton but?you righties?don't understand that to win she does not have to be a saint --she only has to be better than the feckless GOP competition.? The GOP and its candidates are being dragged down by destructive forces.? They lovingly embraced the tea party infection and now it is eating them alive.? "
					+ "@Eric Copt sound logical reasoning in your comment. But 1/3rd plus of GOP representatives don't know what logical means. They are dooming your party for 2016, and maybe for many years to come. "
					+ "The President just shut down funding for our military by vetoing the defense spending authorization. The first time that's ever been done in history based on his reasoning.  I'm still waiting for the WSJ to put that on the front page.  Saving it for the weekend edition editors? "
					+ "I really don't care what the debt limit is -? if congress wants to control it - they should just stop appropriating money.? It is a fake limit that means nothing. Say we had a president who actually wanted to limit spending and the debt limit was approaching.? Would he just refuse to spend money that congress appropriated when the total debt would exceed the limit?? If he did, he would be breaking the law, as congress presumably appropriated and authorized the expenditure.? "
					+ "So the debt limit is a dumb argument to base a fight upon.? Besides, the raise will be what - $500 B.? Like it really matters when we are already $18,100 Bil in debt.? Sort of like being a little pregnant. Not that it will stop Washington from fighting over it.";
		    
		 testAPI test = new testAPI();
		 test.textTest(service, text);
		 
		 
	 }
	

}
