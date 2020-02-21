import de.bezier.guido.*;
int NUM_ROWS = 12;
int NUM_COLS = 12;
int NUM_MINES = (int)(NUM_ROWS * NUM_COLS * 0.1);
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
    while(mines.size() < NUM_MINES){
        int row = (int)(Math.random() * NUM_ROWS);
        int col = (int)(Math.random() * NUM_COLS);
        if(mines.contains(buttons[row][col]))
            setMines();
        else{
            mines.add(buttons[row][col]);
            System.out.println(row + ", " + col);
        }
    }
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
    fill(0);
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
    if(isValid(row, col) == true)
    {
        for(int r = row - 1; r < row + 2; r++)
        {
            for(int c = col - 1; c < col + 2; c++)
            {
                if(isValid(r, c) == true)
                {
                    if(mines.contains(buttons[r][c]))
                        numMines++;
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
                flagged = false;
            else
                flagged = true;
        } 
        else if(mines.contains(this))
        {
            displayLosingMessage();
        }
        else if(countMines(myRow, myCol) > 0)
        {
            setLabel(countMines(myRow, myCol));
        } else {
            for(int r = myRow - 1; r < myRow + 2; r++){
                for(int c = myCol - 1; c < myCol + 2; c++){
                    if(isValid(r, c) && buttons[r][c].clicked == false){
                        buttons[r][c].clicked = true;
                        if(countMines(r, c) > 0)
                            setLabel(countMines(r, c));
                        else
                            mousePressed();
                        // if it doesnt have a label, then press that square again to call the next squares.
                    }
                }
            }
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
