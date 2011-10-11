package com.TUIC.clipon;

import android.app.Activity;
import android.graphics.Canvas;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.os.Handler;
import android.os.HandlerThread;

public class CliponActivity extends Activity {
	/** Called when the activity is first created. */
	public Circle mCircle;
	public Thread thread;
	public static Ball ball[]=new Ball[20];
	static Pin pin[]=new Pin[22];
	public static int ballCount=1;
	public static Launcher launcher;
	boolean flagPlaying = true;
	public int shotAlready=0;


	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setTheme(android.R.style.Theme_Black_NoTitleBar_Fullscreen);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.mCircle = new Circle(this);
//		ball[0] = new Ball();
		pin[0] = new Pin(100,150);
		pin[1] = new Pin(200,150);
		pin[2] = new Pin(300,150);
		pin[3] = new Pin( 20,300);
		pin[4] = new Pin(140,300);
		pin[5] = new Pin(260,300);
		pin[6] = new Pin(380,300);
		pin[7] = new Pin(200,450);
		pin[8] = new Pin(300,450);
		pin[9] = new Pin(100,450);
		pin[10] = new Pin( 20,640);
		pin[11] = new Pin(140,640);
		pin[12] = new Pin(260,640);
		pin[13] = new Pin(380,640);
		pin[14] = new Pin( 20,690);
		pin[15] = new Pin(140,690);
		pin[16] = new Pin(260,690);
		pin[17] = new Pin(380,690);
		pin[18] = new Pin( 20,740);
		pin[19] = new Pin(140,740);
		pin[20] = new Pin(260,740);
		pin[21] = new Pin(380,740);
		launcher = new Launcher();

		setContentView(mCircle);
		
		new Thread(new GameThread()).start();
		// thread = new Thread(this);
		// thread.start();

	}

	@Override
	public void onBackPressed() {

		flagPlaying = false;
		super.onBackPressed();
		this.finish();
	}
	
	@Override
	public void onResume(){
		ball[0]=new Ball();
		ballCount=1;
		super.onResume();
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		// TODO Auto-generated method stub
		int action = event.getActionMasked();

		// action point status
		int actionIndex = event.getActionIndex();
		float actionPointX = event.getX(actionIndex);
		float actionPointY = event.getY(actionIndex) - 60;// offset

		switch (action) {
		case MotionEvent.ACTION_POINTER_DOWN:
			launcher.y = 550;
			break;
		case MotionEvent.ACTION_DOWN:
			launcher.y = actionPointY;
			break;
		
		case MotionEvent.ACTION_MOVE:
			if ((actionPointX > 380 && actionPointX < 470)
					 && actionPointY > 550 && actionPointY < 780) {
				launcher.y = actionPointY;
				// ball.y=actionPointY-120;
				if(actionPointY>480&&shotAlready==1&&ballCount<20)
				{
//					state[j]=0;
//				    flag[j]=0;	
//					ball[j].x=440;
//					ball[j].y=490;
					ball[ballCount] = new Ball();
					ballCount++;
					shotAlready=0;
					
					
					 
				}
			}
			else if (actionPointY<=550)
				launcher.y = 550;
			break;
		case MotionEvent.ACTION_UP:
			launcher.y = 550;
			break;
		}
		return super.onTouchEvent(event);
	}

	class GameThread implements Runnable {
		public void run() {
			int count[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
			int flag[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
			int state[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

			while (flagPlaying) {
				try {
for(int j=0;j<ballCount;j++){
	
					switch (state[j]) {
					case 0:// 祇甮玡
						
						ball[j].y = launcher.y - 60;

						if (launcher.y > 580 && flag[j] == 0) {
							flag[j] = 1;
						}

						if (launcher.y < 570 && flag[j] == 1) {
							state[j] = 1;
							break;
						}

						if (count[j] == 6) {
							count[j] = 0;
							launcher.t_position[count[j]] = launcher.y;
							count[j]++;
						} else {
							launcher.t_position[count[j]] = launcher.y;
							count[j]++;
						}
						break;
					case 1:// 璸衡硉
						for (int i = 0; i < 6; i++)
							if (launcher.t_position[0] < launcher.t_position[i])
								launcher.t_position[0] = launcher.t_position[i];
						ball[j].v = 80*(launcher.t_position[0]-550)/180;
						state[j]=2;
						break;
					case 2:// 瓂笵
						ball[j].v=ball[j].v-1.6f;
						if (ball[j].y > 200&&ball[j].y <= 490)
							
							ball[j].y = ball[j].y - ball[j].v;
						else if(ball[j].y > 490)
							{ball[j].y =490;
						    state[j]=0;
						    flag[j]=0;}
						else state[j]=3;
						break;
					case 3://筁舠
						if (ball[j].y > 30&&ball[j].y <= 200){
						ball[j].degree=Math.asin((200-ball[j].y)/170);
						ball[j].v=ball[j].v-1.6f*(float)Math.cos(ball[j].degree);
						ball[j].y=ball[j].y-ball[j].v*(float)Math.cos(ball[j].degree);
						ball[j].x=270+170*(float)Math.cos(ball[j].degree);
						}
						else if(ball[j].y>200)
							state[j]=2;
						else 
							{state[j]=4;
							shotAlready=1;
							ball[j].degree=3.1415/2;
							ball[j].vx=ball[j].v*(float)Math.sin(ball[j].degree);
							ball[j].vy=ball[j].v*(float)Math.cos(ball[j].degree);
							}
						break;
					case 4://キ┻甮
						
						if(ball[j].y<=30&&ball[j].vy>0)
						{
							ball[j].y=30;
							ball[j].vy=-ball[j].vy*0.5f;
						}
						if(ball[j].x<=30&&ball[j].vx>0&&ball[j].y<630)//オは甮
							{ball[j].vx=-ball[j].vx*0.5f;
							ball[j].x=30;
							}
						if(ball[j].x>=375&&ball[j].vx<0&&ball[j].y<630)//は甮
						{ball[j].vx=-ball[j].vx*0.5f;
						ball[j].x=375;
						}
						
						if(ball[j].y>=630&&ball[j].x>350)//┏场380
							ball[j].x=340;
						if(ball[j].y>=630&&ball[j].x<50)//┏场オ20
							ball[j].x=60;
						if(ball[j].y>=630&&ball[j].x<140&&ball[j].x>120)//┏场オ琖オ140
							ball[j].x=110;
						if(ball[j].y>=630&&ball[j].x>140&&ball[j].x<160)//┏场オ琖140
							ball[j].x=170;
						if(ball[j].y>=630&&ball[j].x<260&&ball[j].x>240)//┏场琖オ260
							ball[j].x=230;
						if(ball[j].y>=630&&ball[j].x>260&&ball[j].x<280)//┏场琖260
							ball[j].x=290;
						
						
						
						
						if(ball[j].y>=730)//┏场は甮
							{
							ball[j].y=730;
							if(ball[j].vy>=-10&&ball[j].vy<=0)
								{
								ball[j].vy=0;
								
								ball[j].vx=ball[j].vx*0.92f;
								
							if(ball[j].vx>=-1&&ball[j].vx<=1)
								ball[j].vx=0;
								}
							else
							{
								ball[j].vy=-ball[j].vy*0.4f;
								
//								ball.vx=ball.vx*0.8f;
							}
							}
						if (ball[j].y > 0&&ball[j].y < 730)
							ball[j].vy=ball[j].vy-1.6f;
						ball[j].x=ball[j].x-ball[j].vx;
						ball[j].y=ball[j].y-ball[j].vy;
						if(ball[j].y>730)
							ball[j].y=730;
						if(ball[j].x<30)
							ball[j].x=30;
						if(ball[j].x>375)
							ball[j].x=375;
						

					break;	
						
					}
}
if(ballCount>=2){
for(int a=0;a<ballCount-1;a++)
	for(int b=a+1;b<ballCount;b++)
		if(Math.abs(Math.hypot((double)(ball[b].x-ball[a].x), (double)(ball[b].y-ball[a].y)))<60&&ball[a].y<640&&ball[b].y<640)
		{
			
			Ball.hit(ball[a],ball[b]);
			
			}
}
for(int a=0;a<ballCount;a++)
	for(int b=0;b<22;b++)
		if(Math.abs(Math.hypot((double)(pin[b].x-ball[a].x), (double)(pin[b].y-ball[a].y)))<40)
		{
			
			Ball.hitPin(ball[a],pin[b]);
			
			}
					Thread.sleep(33);

					//
				}

				catch (InterruptedException e) {
					Thread.currentThread().interrupt();
				}
				mCircle.postInvalidate();
			}
		}
	}

	// while(true){
	//
	//
	//
	// try {
	// while(ballY<300)
	// {
	// ballY=ballY+1;
	// thread.sleep(1000);
	//
	// }
	// ballY=200;
	//
	//
	// } catch (InterruptedException e) {
	// // // TODO Auto-generated catch block
	// // e.printStackTrace();
	// }
	//
	//
	// }




}