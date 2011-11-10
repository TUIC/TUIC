package lab.tuic;

import java.io.IOException;
import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.widget.ImageView;
import android.widget.TextView;

public class TUICVolumeActivity extends Activity {
	/** Called when the activity is first created. */
	int preY = -1;
	int th = 50;
	int th2 = 100;
	private MediaPlayer mMedia;
	private AudioManager audioManager;
	ImageView bt1;
	TextView volumnText;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
		mMedia = MediaPlayer.create(TUICVolumeActivity.this, R.raw.music4);
		findView();

		volumnText.setText("Volumn:"
				+ audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
	}

	void findView() {

		volumnText = (TextView) findViewById(R.id.textView1);
		bt1 = (ImageView) findViewById(R.id.imageView1);
	}

	@Override
	public void onPause() {
		if (mMedia != null) {
			mMedia.stop();
			mMedia.reset();
		}
		super.onPause();
	}

	@Override
	public boolean onTouchEvent(MotionEvent e) {
		if (e.getActionMasked() != 2)

			Log.e("y", e.getActionMasked() + "");
		int y = (int) e.getY();
		if (e.getAction() == MotionEvent.ACTION_DOWN && e.getActionIndex() != 0) {
			preY = y;
		}

		if (e.getActionMasked() == MotionEvent.ACTION_POINTER_1_UP
				|| e.getActionMasked() == MotionEvent.ACTION_UP) {
			if (e.getY(e.getActionIndex()) > 100
					&& e.getY(e.getActionIndex()) < 200) {
				if (e.getX(e.getActionIndex()) < 100) {
					if (mMedia.isPlaying()) {
						bt1.setImageResource(R.drawable.button_start);
						mMedia.pause();
					} else {
						bt1.setImageResource(R.drawable.button_pause);
						mMedia.start();
					}

				} else if (e.getX(e.getActionIndex()) < 200) {
					bt1.setImageResource(R.drawable.button_start);
					if (mMedia != null) {
						mMedia.stop();
						mMedia.reset();
					}
					mMedia = MediaPlayer.create(TUICVolumeActivity.this,
							R.raw.music4);
					try {
						mMedia.prepare();
					} catch (IllegalStateException er) {
						// TODO Auto-generated catch block
						er.printStackTrace();
					} catch (IOException er) {
						// TODO Auto-generated catch block
						er.printStackTrace();
					}
					mMedia.start();
					mMedia.pause();

				}

			}
		}
		if (e.getAction() == MotionEvent.ACTION_MOVE) {
			if (inRange(e.getX(), e.getY())) {
				if (preY == -1 || preY - y > th2 || y - preY > th2) {
					preY = y;
				} else if (preY - y > th) {
					volume(true, preY, y);
					preY = y;
				} else if (preY - y < -th) {
					volume(false, preY, y);
					preY = y;
				}

			}

		}

		return super.onTouchEvent(e);
	}

	void volume(boolean up, int a, int b) {
		if (up) {
			Log.e("vol", "up " + a + " " + b);
			audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC,
					AudioManager.ADJUST_RAISE, 0);
		} else {
			Log.e("vol", "down " + a + " " + b);
			audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC,
					AudioManager.ADJUST_LOWER, 0);
		}
		volumnText.setText("Volumn:"
				+ audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
	}

	boolean inRange(float inX, float inY) {
		if (inX > 400 && inY > 550) {
			return true;
		}
		return false;
	}
}