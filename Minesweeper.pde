import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
int NUM_MINES = (int)(NUM_ROWS * NUM_COLS * 0.21);
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
int ccc = 0;
void setup ()
{
    size(600, 650);
    textAlign(CENTER,CENTER);
    textSize(10);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r, c); 
    }
    mines = new ArrayList <MSButton>();
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
        }
    }
}

public void draw ()
{
    background( 25, 75, 76 );
    if(isWon() == true){
        displayWinningMessage();
        noLoop();
    }
    ccc++;
    if(ccc > 1)
        setMines();
    textSize(25);
    fill(200);
    text("There are " + NUM_MINES + " mines.", 300, 20);
    textSize(10);
}

public boolean isWon()
{
    int clickCount = 0;
    int mineCount = 0;
    /*for(int i = 0; i < mineCount; i++){
        if(mines.get(i).isFlagged())
            mineCount++;
        if(mineCount >= NUM_MINES)
            return true;
    }*/
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(buttons[r][c].isClicked())
                clickCount++;
        }
    }

    if(clickCount >= NUM_ROWS * NUM_COLS - NUM_MINES)
        return true;
    return false;
}

public void displayLosingMessage()
{
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 - 4].setLabel("Y");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 - 3].setLabel("o");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 - 2].setLabel("u");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2].setLabel("L");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 + 1].setLabel("o");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 + 2].setLabel("s");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 + 3].setLabel("e");
    buttons[NUM_ROWS/2 - 1][NUM_COLS / 2 + 4].setLabel("!");
}

public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("Y");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("o");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("u");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("W");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("i");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("n");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("!");
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

public void keyPressed(){
    if(key == 'r' || key == 'R'){
        for(int i = mines.size() - 1; i >= 0; i--){
            mines.remove(i);
        }
        setMines();
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            buttons[r][c].setFlagged(false);
            buttons[r][c].setClicked(false);
            buttons[r][c].setLabel("");
        }
    }
    loop();
    }
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
        y = myRow*height + 50;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(mouseButton == LEFT)
            clicked = true;
        if(mouseButton == RIGHT)
        {
            if(flagged == true)
                flagged = false;
            else if(!clicked)
                flagged = true;
        } 
        else if(mines.contains(this))
        {
            displayLosingMessage();
            noLoop();
        }
        else if(countMines(myRow, myCol) > 0)
        {
            setLabel(countMines(myRow, myCol));
        } else {
            for(int r = myRow - 1; r < myRow + 2; r++){
                for(int c = myCol - 1; c < myCol + 2; c++){
                    if(isValid(r, c) && !buttons[r][c].isClicked() && !(r == myRow && c == myCol)){
                        if(buttons[r][c].isFlagged())
                            buttons[r][c].flagged = false;
                        buttons[r][c].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (flagged)
            fill(40);
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
        myLabel = "" + newLabel;
    }

    public boolean isFlagged()
    {
        return flagged;
    }

    public boolean isClicked()
    {
        return clicked;
    }

    public void setFlagged(boolean t)
    {
        flagged = t;
    }

    public void setClicked(boolean t)
    {
        clicked = t;
    }
}

