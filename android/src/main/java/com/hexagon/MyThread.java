package com.hexagon;

import android.graphics.Canvas;
import android.view.SurfaceHolder;

public class MyThread extends Thread {

  private SurfaceHolder msurfaceHolder;
  private MyView mMyView;
  private boolean mrun =false;

  public MyThread(SurfaceHolder holder, MyView myView) {

    msurfaceHolder = holder;
    mMyView=myView;
  }

  public void startrun(boolean run) {

    mrun=run;
  }

  @Override
  public void run() {

    super.run();
    Canvas canvas;
    while (mrun) {
      canvas=null;
      try {
        canvas = msurfaceHolder.lockCanvas(null);
        synchronized (msurfaceHolder) {
          mMyView.draw(canvas);
        }
      } finally {
        if (canvas != null) {
          msurfaceHolder.unlockCanvasAndPost(canvas);
        }
      }
    }
  }

}
