# WhatsApp-Chat-Data-Transformation-in-Power-Query
 
This project focuses on the transformation of raw WhatsApp text data into a structured tabular format for analysis in your choice of Business Intelligence tool. The transformation script is written in the M language which is available in Microsoft Power BI, Excel or Power BI Dataflows online. 

To use this script effectively,

0. Export your WhatsApp chat into txt file by going to the settings section > Export Chat > Export Without Media
1. Access the Power Query component of either of Power BI, Excel or Dataflows.
2. Insert a new blank query

![image](https://user-images.githubusercontent.com/30422857/225646969-cc526733-e716-4720-88c4-6ffb16bc7a64.png)

3. Modify the query from the Advanced Editor
4. Copy and paste the M script into the Advanced Editor
5. Modify the *Source* step to include the exact location of your exported WhatsApp .txt file 
![image](https://user-images.githubusercontent.com/30422857/225648717-8f6d4374-60ea-4ecd-9dfb-2ef625e04e5b.png)
6. Rename the query to *messages* or a more appropriate name
