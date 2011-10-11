package com.TUIC.clipon;

public class Ball {

	float x=440 ;
	float y=490;
	double degree=0;
	float v=0;
	float vx=0;
	float vy=0;
	int size=30;
//	void hit(Ball b){
//	float x=vx;
//	this.vx=b.vx;
//	b.vx=x;
//	}
	
	static void hit(Ball a,Ball b){
		
		double length =Math.abs(Math.hypot((double)(b.x-a.x), (double)(b.y-a.y)));
		double tempDegree=Math.atan(Math.abs(a.y-b.y)/Math.abs(a.x-b.x));
		a.v=(float)(Math.hypot((double)Math.abs(a.vx), (double)Math.abs(a.vy)));

		a.degree=Math.abs(Math.atan(a.vy/a.vx));
		b.degree=Math.abs(Math.atan(b.vy/b.vx));
		
		
		float z=0.1f;//計算相切
		for (z=0.01f;Math.hypot((a.x+(a.vx*z)-(b.x+(b.vx*z))), (a.y+(a.vy*z)-(b.y+(b.vy*z))))<60;z=z+0.05f)
		{}
		
		a.x=a.x+a.vx*z;
		a.y=a.y+a.vy*z;
		b.x=b.x+b.vx*z;
		b.y=b.y+b.vy*z;
		
		
//		b.x=b.x+b.vx*((float)(60-length)/b.v);
//		b.y=b.y+b.vy*((float)(60-length)/b.v);
		
		
		
		float tmpvx=a.vx;
		float tmpvy=a.vy;
//		a.vx=a.vx-a.vx*(float)Math.cos(a.degree-tempDegree)+b.vx*(float)Math.cos(b.degree-tempDegree);
//		a.vy=a.vy-a.vy*(float)Math.cos(a.degree-tempDegree)+b.vy*(float)Math.cos(b.degree-tempDegree);
//		b.vx=b.vx-b.vx*(float)Math.cos(b.degree-tempDegree)+tempvx*(float)Math.cos(b.degree-tempDegree);
//		b.vy=b.vy-b.vy*(float)Math.cos(b.degree-tempDegree)+tempvy*(float)Math.cos(b.degree-tempDegree);
		if(a.x>=b.x&&a.y<=b.y)//1
		{
			a.vx=0.7f*(a.vx-a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree)
					-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.7f*(a.vy+a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree)
					+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree));
			b.vx=0.7f*(b.vx+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree)
					+tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			b.vy=0.7f*(b.vy-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree)
					-tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));
			
		}
		else if(a.x<b.x&&a.y<b.y)//2
		{
			a.vx=0.7f*(a.vx+a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree)
					+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.7f*(a.vy+a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree)
					+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree));
			b.vx=0.7f*(b.vx-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree)
					-tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			b.vy=0.7f*(b.vy-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree)
					-tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));
			
		}
		
		else if(a.x<=b.x&&a.y>=b.y)//3
		{
			a.vx=0.7f*(a.vx+a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree)
					+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.7f*(a.vy-a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree)
					-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree));
			b.vx=0.7f*(b.vx-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree)
					-tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			b.vy=0.7f*(b.vy+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree)
					+tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));
					}
		else if(a.x>b.x&&a.y>b.y)//4
		{
			a.vx=0.7f*(a.vx-a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree)
					-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.7f*(a.vy-a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree)
					-b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree));
			b.vx=0.7f*(b.vx+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.cos(tempDegree)
					+tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			b.vy=0.7f*(b.vy+b.v*(float)Math.cos(Math.abs(b.degree-tempDegree))*(float)Math.sin(tempDegree)
					+tmpvx*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));
					}
		
		
		
	}
	
	static void hitPin(Ball a,Pin b){
		float z=0.1f;//計算相切
		for (z=0.01f;Math.hypot((a.x+(a.vx*z)-b.x), (a.y+(a.vy*z)-b.y))<40;z=z+0.1f)
		{}
		
		
		a.x=a.x+(float)a.vx*z;
		a.y=a.y+(float)a.vy*z;
		
		
		a.vy=a.vy-1.6f;
//		double length =Math.abs(Math.hypot((double)(b.x-a.x), (double)(b.y-a.y)));
		double tempDegree=Math.atan(Math.abs(a.y-b.y)/Math.abs(a.x-b.x));
		a.v=(float)(Math.hypot((double)Math.abs(a.vx), (double)Math.abs(a.vy)));
		
		
		a.degree=Math.atan(Math.abs(a.vy)/Math.abs(a.vx));
		if(a.x>=b.x&&a.y<=b.y)//1
		{
			a.vx=0.7f*(a.vx-2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.5f*(a.vy+2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));
			
		}
		else if(a.x<b.x&&a.y<b.y)//2
		{
			a.vx=0.7f*(a.vx+2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.5f*(a.vy+2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));

		}
		
		else if(a.x<=b.x&&a.y>=b.y)//3
		{
			a.vx=0.5f*(a.vx+2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.5f*(a.vy-2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));

		}
		else if(a.x>b.x&&a.y>b.y)//4
		{
			a.vx=0.5f*(a.vx-2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.cos(tempDegree));
			a.vy=0.5f*(a.vy-2.0f*a.v*(float)Math.cos(Math.abs(a.degree-tempDegree))*(float)Math.sin(tempDegree));

		}
		

		float tempvx=-a.v*(float)Math.cos(a.degree-tempDegree);
		float tempvy=a.v*(float)Math.sin(a.degree-tempDegree);
		
		
//		a.vx=-a.vx;
		
		
		
//		a.vx=a.vx+2.0f*a.v*(float)Math.cos(a.degree-tempDegree)*(float)Math.cos(tempDegree);
//		a.vy=a.vy+2.0f*a.v*(float)Math.cos(a.degree-tempDegree)*(float)Math.sin(tempDegree);
		
//		a.vx=tempvx*(float)Math.cos(tempDegree)-tempvy*(float)Math.sin(tempDegree);
//		a.vy=-tempvx*(float)Math.sin(tempDegree)-tempvy*(float)Math.cos(tempDegree);

	}
	
}
