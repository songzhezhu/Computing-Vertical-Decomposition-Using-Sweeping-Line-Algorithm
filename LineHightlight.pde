/*--------------------------------------------------------------------------------------------
 * Author: Songzhe Zhu
 * 
 * Description: Main program to draw lower envelope read from a file
 *              Gets user input to open a file.
 *
 *-------------------------------------------------------------------------------------------
 */

import controlP5.*; 
import java.util.Arrays;


/**** Global Variables *****/
ControlP5 cp5;
Button button,button2;
int clicks = 0;
int start=0;
int totalsegs=0;
Segment upperbound, lowerbound;
ArrayList<Segment> segHL;
Segment[] segs;
Segment[] LE;
Boolean[] checker;
ArrayList<Segment> segLE;
boolean flag = true, drawSegsFlag = false;
//MinHeap heap, Minheap;
PrintWriter output;
String filename = "";
ArrayList<Segment> list = new ArrayList<Segment>();

void settings()
{
    size(800,900);
}

void setup()
{
    /**** Added console for reading user input *****/
    cp5 = new ControlP5(this);
    cp5.addTextfield("input")
       .setPosition(width-220, height-70)
       .setSize(200,40)
       .setFont(createFont("arial", 20))
       .setFocus(true)
       .setColor(255);
       
    //Get label from Control
    Label label = cp5.get(Textfield.class, "input").getCaptionLabel();
    label.setColor(0).setText("Enter Filename");
    button = new Button("Click", 10, 825, 100, 35);
    button2 = new Button("Restart", 150, 825, 100, 35);
    //heap = new MinHeap();
    //Minheap = new MinHeap();
    checker = new Boolean[801];
    Arrays.fill(checker, false);
}

/*
* loadData()
* Purpose: Load data from file to draw segments
* Parameters: filename - name of file to be opened
*
*/
void loadData(String filename)
{
    BufferedReader read;
    
    
    String str = null;
    float x1 , x2, y1, y2;
    int i =2;
    
    try{
        read = createReader(filename);
        while((str = read.readLine()) != null)
        {
            if(str.length() == 1) //Check to see if we are reading the first line
            {
              totalsegs = Integer.parseInt(str);  
              segs = new Segment[Integer.parseInt(str)+2];
              upperbound = new Segment("segment-0", 0, 400, 800,400);
              lowerbound = new Segment("segment-0", 0, 0, 800,0);
              segs[0] = upperbound;
              segs[1] = lowerbound;
              //totalsegs += 1;
            }
            else{ // Readline to get values for the segment to be created
                str = str.replaceAll("\\s+", " ");
                String[] ary = str.split(" "); //Split string on spaces
               
                // Get position values
                x1 = Float.parseFloat(ary[0]);
                y1 = Float.parseFloat(ary[1]);
                x2 = Float.parseFloat(ary[2]);
                y2 = Float.parseFloat(ary[3]);
                
                if(x1 < 0 || x1 > 800 || x2 < 0 || x2 > 800 || y1 < 0 || y1 > 400 || y1 < 0 || y2 > 400){
                   println("Segment "+i+"is too large/small to fit the screen!!");
                   i++;
                   continue;
                }
                
                //create new segment
                Segment seg = new Segment("segment-" + i, x1, y1, x2, y2);
                seg.setStrokeWeight(3);
                segs[i] = seg;
                i++;
            }          
        }
    }catch(IOException e)
    {
        println("Something bad happened");
        e.printStackTrace();
    }
    segs = clean(segs);
    //for(Segment seg: segs){
    //  println(seg);
    //}
    //println();
    //LE = new Segment[2*totalsegs-1];
    //LE = GenerateLowerEnvelope(segs);
    //ArrayList<Segment> list = new ArrayList<Segment>();
    //for(Segment s: LE){
    //  if(s != null)
    //  list.add(s);
    //}
    //LE = list.toArray(new Segment[list.size()]);
    //segs = heapsort(LE);
    //for(Segment seg: LE){
    //  println(seg);
    //}
    //println();
    segHL = new ArrayList<Segment>();
    drawSegsFlag = true;
}

//Get rid of null pointers in the array
public Segment[] clean(Segment[] a) {
   ArrayList<Segment> removedNull = new ArrayList<Segment>();
   for (Segment str : a)
      if (str != null)
         removedNull.add(str);
   return removedNull.toArray(new Segment[0]);
}

/*
*Generate Min-Heap for the current segments stored in 
*segs.
*RETURN: Print out the sorted segments
*/
//void generateHeap(MinHeap hp, Segment[] segs){
//   for(Segment seg: segs){
//       hp.insert(seg);
//   }
//}

///*
//* Heap sort a array of segment
//*/
//Segment[] heapsort(Segment[] seg){
//  Segment[] tmp = new Segment[seg.length];
//  generateHeap(heap, seg);
//  int i=0;
//  while(!heap.isEmpty()){
//    tmp[i] = heap.extractMin();
//    i++;
//  }
//  return tmp;
//}

////Fill the boolean[]checker by boolean
//void fillChecker(float left, float right){
//  for(float i=left; i<right; i++){
//    checker[Math.round(i)]=true;
//  }
//}

///*
//* 0: all been taken
//* 1: all not been taken
//* 2: part of been taken
//*/
//int checkUsed(float left, float right){
//  int count =0;
//  int other =0;
//  for(float i=left; i<right; i++){
//    if(checker[Math.round(i)]==true)
//      count++;
//    if(checker[Math.round(i)]==false)
//      other++;
//  }
//  if(count==right-left)
//    return 0;
//  if(other==right-left)
//    return 1;
//  return 2;
//}

///*find the open spot for a segment by
//* look over the checker[].
//*/
//ArrayList<Segment> findNewSegment(Segment seg){
//  float x1=-1, x2=0;
//  ArrayList<Segment> list = new ArrayList<Segment>();
//  Segment newseg = new Segment("new", 0, 0, 0);
//  for(float j=seg.getX1(); j<seg.getX2(); j++){
//    if(checker[Math.round(j)]==true){
//      if(x1==-1 || x2==0){}
//      else{
//        //println(x2);
//        //println("000");
//        //println(x1);
//        newseg = new Segment("new", x1, x2, seg.getY());
//        fillChecker(x1, x2);
//        list.add(newseg);
//        x1=-1;
//        x2=0;
//      }
//    }
//    else{
//      if(x1==-1){
//         x1=j; 
//      }
//      x2=j+1;
    
//    }
//  }
//  if(x1==-1 && x2==0){}
//  else{
//    newseg = new Segment("new", x1, x2, seg.getY());
//    fillChecker(x1, x2);
//    list.add(newseg);
//  }
//  return list;
//}


///*
//* Find the lower envelope for each segment
//*/

//Segment[] GenerateLowerEnvelope(Segment[] seg){
//  Segment[] lowerE = new Segment[800];
//  Segment[] lowerE2 = new Segment[800]; 
//  float realX2=0, minX1=0, maxX1;
//  for(int y=0; y<=400; y++){
//    for(int i=0; i<seg.length; i++){
//      if(y == seg[i].getY()){
//         if(i==0){
//            lowerE[i] = new Segment("LE:"+i, seg[i].getX1(), seg[i].getX2(), seg[i].getY());
//            fillChecker(seg[i].getX1(), seg[i].getX2());
//         }
//         else{
//          if(seg[i].getX2() > seg[i-1].getX2() && seg[i].getX1() < seg[i-1].getX1()){
//            if(checkUsed(seg[i].getX1(), seg[i-1].getX1())==0){}
//            else if(checkUsed(seg[i].getX1(), seg[i-1].getX1())==1){
//              //println("checkcheck1.1");
//              lowerE[i] = new Segment("LE:"+i, seg[i].getX1(), seg[i-1].getX1(), seg[i].getY());
//              //println(lowerE[i]);
//              //println(seg[i].getX1());
//               //println(seg[i-1].getX1());
//              fillChecker(seg[i].getX1(), seg[i-1].getX1());
//            }
//            else{
//              //println("checkcheck1.2 ");
//              ArrayList<Segment> pass = new ArrayList<Segment>();
//                 pass = findNewSegment(seg[i]);
//                 //println(pass.isEmpty());
//                 for(int j=0; j<pass.size(); j++){
//                    lowerE[i+j] = pass.get(j); 
//                 }
//            }
            
//            if(checkUsed(seg[i-1].getX2(), seg[i].getX2())==0){}
//            else if(checkUsed(seg[i-1].getX2(), seg[i].getX2())==1){
//              //println("checkcheck2");
//              lowerE2[i] = new Segment("LE2:"+i, seg[i-1].getX2(), seg[i].getX2(), seg[i].getY());
//              fillChecker(seg[i-1].getX2(), seg[i].getX2());
//            }
//            else{
//              //println("checkcheck1.3 ");
//              ArrayList<Segment> pass = new ArrayList<Segment>();
//                 pass = findNewSegment(seg[i]);
//                 //println(pass.isEmpty());
//                 for(int j=0; j<pass.size(); j++){
//                    lowerE2[i+j] = pass.get(j); 
//                 }
//            }
//           }
           
//           else if(seg[i].getX2() > seg[i-1].getX2() && seg[i].getX1() > seg[i-1].getX1()){
//             if(seg[i].getX1() < seg[i-1].getX2()){
//               //println("check"+checkUsed(seg[i-1].getX2(), seg[i].getX2()));
//               if(checkUsed(seg[i-1].getX2(), seg[i].getX2())==0){}
//               else if(checkUsed(seg[i-1].getX2(), seg[i].getX2())==1){
//                 lowerE[i] = new Segment("LE2:"+i, seg[i-1].getX2(), seg[i].getX2(), seg[i].getY());
//                 fillChecker(seg[i-1].getX2(), seg[i].getX2());
//               }
//               else{
//                 ArrayList<Segment> pass = new ArrayList<Segment>();
//                 pass = findNewSegment(seg[i]);
//                 for(int j=0; j<pass.size(); j++){
//                    lowerE[i+j] = pass.get(j); 
//                 }
//               }
//             }
//             else{
//               maxX1 = seg[i].getX1();
//               if(checkUsed(maxX1, seg[i].getX2())==0){}
//               else if(checkUsed(maxX1, seg[i].getX2())==1){
//               lowerE2[i] = new Segment("LE2:"+i, maxX1, seg[i].getX2(), seg[i].getY());
//               fillChecker(maxX1, seg[i].getX2());
//               }
//               else{
//                 ArrayList<Segment> pass = new ArrayList<Segment>();
//                 pass =  findNewSegment(seg[i]);
//                 for(int j=0; j<pass.size(); j++){
//                    lowerE2[i+j] = pass.get(j); 
//                 }
//               }
//             }
//           }
           
//           else if(seg[i].getX2() < seg[i-1].getX2() && seg[i].getX1() < seg[i-1].getX1()){
//             if(seg[i].getX2() < seg[i-1].getX1())
//               minX1 = seg[i].getX2();
//              else
//                minX1 = seg[i-1].getX1();
             
//             if(checkUsed(seg[i].getX1(), minX1)==0){}
//             else{
//               lowerE[i] = new Segment("LE2:"+i, seg[i].getX1(), minX1, seg[i].getY());
//               fillChecker(seg[i].getX1(), minX1);
//             }
//           }
//           else{
//           }
//         }
//      }
//    }
//  }
//  //combine the two arrays of lower envelope into one and get rid of the null pointers
//  Segment[] combine = new Segment[lowerE.length + lowerE2.length];
//  int count = 0;
//  for(int i=0; i<lowerE.length; i++){
//     combine[i] = lowerE[i];
//     count++;
//  }
//  for(int j=0; j<lowerE2.length; j++){
//     combine[count++] = lowerE2[j]; 
//  }
//  return combine;
//}

////The divide-and-concur structure
//ArrayList<Segment> DQLowerEnvelope(Segment[] array, int left, int right){
//  ArrayList<Segment> subList1= new ArrayList<Segment>();
//  ArrayList<Segment> subList2= new ArrayList<Segment>();
//  ArrayList<Segment> total= new ArrayList<Segment>();
//  if(left == right){
//     total.add(array[left]); 
//     return total;
//  }
//  else{
//     int mid = (left+right) / 2;
//     subList1 = DQLowerEnvelope(array, left, mid);
//     subList2 = DQLowerEnvelope(array, mid+1, right);
//     total = merge(subList1, subList2);
//  }
//  return total;
//}

////Merge part I used min heap to merge.
////Put two sub-list into a min heap and
////use extractMin() to find the lowest segment.
//ArrayList<Segment> merge(ArrayList<Segment> sub1, ArrayList<Segment> sub2){
//  ArrayList<Segment> mergedList = new ArrayList<Segment>();
//  for(int i=0; i<sub1.size(); i++){
//    Minheap.insert(sub1.get(i));
//  }
//  for(int i=0; i<sub2.size(); i++){
//    Minheap.insert(sub2.get(i));
//  }
//  while(!Minheap.isEmpty()){
//     mergedList.add(Minheap.extractMin()); 
//  }
//  return mergedList;
//}

////merge two lists into one by order.
//ArrayList<Segment> mergeList(ArrayList<Segment> sub1, ArrayList<Segment> sub2, int size){
//  ArrayList<Segment> mergedList = new ArrayList<Segment>();
//  int i=0, j=0, k=0, m=size/2; 
  
//  while(i<m && j<size){
//    if(sub1.get(i).getY() < sub2.get(j).getY()){
//        mergedList.add(k, sub1.get(i));
//        i++;
//        k++;
//    }
//    else{
//       mergedList.add(k, sub2.get(j));
//       j++;
//       k++;
//    }
//  }
//  return mergedList;
//}

void draw()
{
    background(255);
    button.buttonDraw();
    //button2.buttonDraw();
    
    /*Check to see if segments need to be drawn.
    * Flag will be turned on once a file has been read
    */
    if(drawSegsFlag){
        // Draw segments in array
        for(Segment seg: segs){
            seg.drawSeg();
        }
    
        //Draw highlight
        //for(Segment seg: segHL){
        //    seg.drawSeg();
        //}
    }
}

//void mousePressed()
//{
//    if(button.mouseOver())
//    {
//       clicks++;
//       Segment cp = new Segment("segment-0", 0, 0, 0);
       
//       if (clicks <= LE.length) {

//         segLE = new ArrayList<Segment>();
//         segLE = DQLowerEnvelope(LE, 0, LE.length-1);
//         //println(segLE);
//         cp = segLE.get(clicks-1);
//         cp.setStrokeWeight(8);
//       }
//       else {
//         clicks = LE.length+1;
//         String outfilename = filename.substring(0,filename.lastIndexOf('.')) + ".out";
//         output = createWriter(outfilename);
//         for(Segment se: segHL){
//           output.println(se);
//         }
//         output.flush();
//         output.close();
//         println("DONE!!!!!");
//         exit();
//        //text("Done!   \\_(ʘ_ʘ)_/", 130, 200);
//       } 
//       segHL.add(cp);
//       println(segHL);
//   }
   
//   //if(button2.mouseOver()){
//   //  keyPressed();
//   //  setup();
//   //}
//}

/* Check to see if the ENTER key has been pressed*/
void keyPressed()
{
    //String filename = "";
    if(key == ENTER)
    {
        //Get string from text field
        filename = cp5.get(Textfield.class, "input").getText()+".in"; 
        
        // CHeck to make sure string is not empty/null
        if(filename != null && !filename.isEmpty())
        {
            cp5.get(Textfield.class, "input").clear(); // Clear text in text field
            loadData(filename);       
        }
    }
}