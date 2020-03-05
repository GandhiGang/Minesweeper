import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private int NUM_BOMBS = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();
private boolean gameOver = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < buttons.length; i++){
        for(int j = 0; j < buttons[i].length; j++){
            buttons[i][j] = new MSButton(i,j);
        }
    }
    setMines();    
}
public void setMines()
{
    while(mines.size()<NUM_BOMBS){
        int f = (int)(Math.random()*NUM_ROWS);
        int g = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[f][g]))
            mines.add(buttons[f][g]);
    }   
}

public void draw ()
{
    background( 0 );
    if(gameOver){
        if(isWon()){
            displayWinningMessage();
            noLoop();
        }
        else{
            displayLosingMessage();
            noLoop();
        }
    }
}

public boolean isWon()
{
    for(int i = 0; i < NUM_ROWS; i++){
        for(int j = 0; j < NUM_COLS; j++){
            if(!mines.contains(buttons[i][j])&&(!buttons[i][j].isClicked()||buttons[i][j].isFlagged()))
                return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    println("Aiyaa");
}
public void displayWinningMessage()
{
    println("Hen Hao");
}
public boolean isValid(int r, int c)
{
    if(r>= 0 && r < NUM_ROWS && c>=0 && c<NUM_COLS)
        return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i <= row+1; i++){
        for(int j = col-1; j <= col+1; j++){
            if(isValid(i,j)){
                if(mines.contains(buttons[i][j]))
                    numMines++;
            }
        }
    }
    if(mines.contains(buttons[row][col]))
        numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
            if(flagged == true){
                flagged = false;
                clicked = false;
            }
            else
                flagged = true;    
        }
        else if(mines.contains(buttons[myRow][myCol])){
            gameOver = true;
        }
        else if(countMines(myRow, myCol)>0)
            myLabel = Integer.toString(countMines(myRow, myCol));
        else{
            if(isValid(myRow-1,myCol-1) && !buttons[myRow-1][myCol-1].isClicked())
                buttons[myRow-1][myCol-1].mousePressed();
            if(isValid(myRow-1,myCol) && !buttons[myRow-1][myCol].isClicked())
                buttons[myRow-1][myCol].mousePressed();
            if(isValid(myRow-1,myCol+1) && !buttons[myRow-1][myCol+1].isClicked())
                buttons[myRow-1][myCol+1].mousePressed();
            if(isValid(myRow,myCol-1) && !buttons[myRow][myCol-1].isClicked())
                buttons[myRow][myCol-1].mousePressed();
            if(isValid(myRow,myCol+1) && !buttons[myRow][myCol+1].isClicked())
                buttons[myRow][myCol+1].mousePressed();
            if(isValid(myRow+1,myCol-1) && !buttons[myRow+1][myCol-1].isClicked())
                buttons[myRow+1][myCol-1].mousePressed();
            if(isValid(myRow+1,myCol) && !buttons[myRow+1][myCol].isClicked())
                buttons[myRow+1][myCol].mousePressed();
            if(isValid(myRow+1,myCol+1) && !buttons[myRow+1][myCol+1].isClicked())
                buttons[myRow+1][myCol+1].mousePressed();
        }
        if(isWon()){
            gameOver = true;
        }

    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
     public boolean isClicked()
    {
        return clicked;
    }
}
