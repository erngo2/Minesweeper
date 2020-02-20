import de.bezier.guido.*;
int NUM_ROWS = 11;
int NUM_COLS = 11;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r, c); 
    }
    mines = new ArrayList <MSButton>();
    
    setMines();
}

public void setMines()
{
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if(mines.contains(buttons[row][col]))
        setMines();
    else
        mines.add(buttons[row][col]);
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon()
{
    //your code here
    return false;
}

public void displayLosingMessage()
{
    text("hadhasdhsakjda", 300, 300);
}

public void displayWinningMessage()
{
    //your code here
}

public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0)
        return true;
    return false;
}

public int countMines(int row, int col)
{
    int numMines = 0;
    if(isValid(row, col) == true){
    for(int r = -1; r < 2; r++){
      for(int c = -1; c < 2; c++){
        if(isValid(row + r, col + c) == true){
          if(row + r != row || col + c != col){
            if(mines.contains(this))
              numMines++;
          }
        }
      }
    }
  }    
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
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
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
        if(mouseButton == RIGHT)
        {
            if(flagged == true)
            {
                flagged = false;
            }
            flagged = true;
        } 
        else if(mines.contains(this))
        {
            displayLosingMessage();
        }
        else if(countMines() > 0)
        {
        }

        //your code here
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
}
