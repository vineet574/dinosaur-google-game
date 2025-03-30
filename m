import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.ArrayList;
import java.util.Random;

public class DinoGame extends JPanel implements ActionListener, KeyListener {
    int dinoX = 50, dinoY = 250, dinoSize = 50;
    int velocity = 0, gravity = 1;
    boolean jumping = false, gameOver = false;
    ArrayList<Rectangle> obstacles;
    Timer timer;
    int score = 0;

    public DinoGame() {
        JFrame frame = new JFrame("Dino Game");
        frame.setSize(800, 400);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.add(this);
        frame.addKeyListener(this);
        frame.setResizable(false);
        frame.setVisible(true);
        
        obstacles = new ArrayList<>();
        timer = new Timer(20, this);
        timer.start();
        addObstacle();
    }

    public void addObstacle() {
        int x = 800;
        int height = 50;
        int width = 20;
        obstacles.add(new Rectangle(x, 300 - height, width, height));
    }

    public void actionPerformed(ActionEvent e) {
        if (!gameOver) {
            velocity += gravity;
            dinoY += velocity;
            if (dinoY >= 250) {
                dinoY = 250;
                jumping = false;
            }

            for (int i = 0; i < obstacles.size(); i++) {
                obstacles.get(i).x -= 5;
            }

            if (!obstacles.isEmpty() && obstacles.get(0).x < -20) {
                obstacles.remove(0);
                addObstacle();
                score++;
            }

            checkCollision();
        }
        repaint();
    }

    public void checkCollision() {
        for (Rectangle obs : obstacles) {
            if (obs.intersects(new Rectangle(dinoX, dinoY, dinoSize, dinoSize))) {
                gameOver = true;
                timer.stop();
            }
        }
    }

    public void keyPressed(KeyEvent e) {
        if (e.getKeyCode() == KeyEvent.VK_SPACE && !jumping) {
            velocity = -15;
            jumping = true;
        }
    }

    public void keyReleased(KeyEvent e) {}
    public void keyTyped(KeyEvent e) {}

    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, getWidth(), getHeight());

        g.setColor(Color.BLACK);
        g.fillRect(dinoX, dinoY, dinoSize, dinoSize);

        g.setColor(Color.GREEN);
        for (Rectangle obs : obstacles) {
            g.fillRect(obs.x, obs.y, obs.width, obs.height);
        }

        g.setColor(Color.RED);
        g.drawLine(0, 300, 800, 300);

        g.setColor(Color.BLACK);
        g.setFont(new Font("Arial", Font.BOLD, 20));
        g.drawString("Score: " + score, 650, 50);

        if (gameOver) {
            g.setFont(new Font("Arial", Font.BOLD, 40));
            g.drawString("Game Over!", 300, 200);
        }
    }

    public static void main(String[] args) {
        new DinoGame();
    }
}
