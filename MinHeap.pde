//import java.util.ArrayList;

//public class MinHeap {

//    private ArrayList<Segment> list;

//    public MinHeap() {

//        this.list = new ArrayList<Segment>();
//    }

//    public MinHeap(ArrayList<Segment> items) {

//        this.list = items;
//        buildHeap();
//    }

//    public void insert(Segment seg) {
//      //Float item = seg.getY();
//        list.add(seg);
//        int i = list.size() - 1;
//        int parent = parent(i);

//        while (parent != i && list.get(i).getY() < list.get(parent).getY()) {

//            swap(i, parent);
//            i = parent;
//            parent = parent(i);
//        }
//    }

//    public void buildHeap() {

//        for (int i = list.size() / 2; i >= 0; i--) {
//            minHeapify(i);
//        }
//    }

//    public Segment extractMin() {

//        if (list.size() == 0) {

//            throw new IllegalStateException("MinHeap is EMPTY");
//        } else if (list.size() == 1) {

//            Segment min = list.remove(0);
//            return min;
//        }

//        // remove the last item ,and set it as new root
//        Segment min = list.get(0);
//        Segment lastItem = list.remove(list.size() - 1);
//        list.set(0, lastItem);

//        // bubble-down until heap property is maintained
//        minHeapify(0);

//        // return min key
//        return min;
//    }

//    public void decreaseKey(int i, Segment key) {

//        if (list.get(i).getY() < key.getY()) {

//            throw new IllegalArgumentException("Key is larger than the original key");
//        }

//        list.set(i, key);
//        int parent = parent(i);

//        // bubble-up until heap property is maintained
//        while (i > 0 && list.get(parent).getY() > list.get(i).getY()) {

//            swap(i, parent);
//            i = parent;
//            parent = parent(parent);
//        }
//    }

//    private void minHeapify(int i) {

//        int left = left(i);
//        int right = right(i);
//        int smallest = -1;

//        // find the smallest key between current node and its children.
//        if (left <= list.size() - 1 && list.get(left).getY() < list.get(i).getY()) {
//            smallest = left;
//        } else {
//            smallest = i;
//        }

//        if (right <= list.size() - 1 && list.get(right).getY() < list.get(smallest).getY()) {
//            smallest = right;
//        }

//        // if the smallest key is not the current key then bubble-down it.
//        if (smallest != i) {

//            swap(i, smallest);
//            minHeapify(smallest);
//        }
//    }

//    public Float getMin() {

//        return list.get(0).getY();
//    }

//    public boolean isEmpty() {

//        return list.size() == 0;
//    }

//    private int right(int i) {

//        return 2 * i + 2;
//    }

//    private int left(int i) {

//        return 2 * i + 1;
//    }

//    private int parent(int i) {

//        if (i % 2 == 1) {
//            return i / 2;
//        }

//        return (i - 1) / 2;
//    }

//    private void swap(int i, int parent) {

//        Segment temp = list.get(parent);
//        list.set(parent, list.get(i));
//        list.set(i, temp);
//    }
    

//  public void printheap() {
//    // TODO Auto-generated method stub
//    System.out.println(list);
//  }
//}