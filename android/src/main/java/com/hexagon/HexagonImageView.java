package com.hexagon;

import static java.lang.Math.cos;
import static java.lang.Math.sin;
import static java.lang.Math.toRadians;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.CornerPathEffect;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PathEffect;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Region;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.util.AttributeSet;

import androidx.annotation.ColorInt;
import androidx.appcompat.widget.AppCompatImageView;

public class HexagonImageView extends AppCompatImageView {

    private final RectF tempCornerArcBounds = new RectF();
    private Path hexagonPath;
    private Path hexagonBorderPath;
    private float radius;
    private Bitmap image;
    private int viewWidth;
    private int viewHeight;
    private Paint paint;
    private BitmapShader shader;
    private Paint paintBorder;
    private int mBorderWidth = 4;
    private int mSideCount=6;
    private int  mCornerRadius=0;

    float mCenterX, mCenterY=0;
    public HexagonImageView(Context context) {
        super(context);
        setup();
    }

    public HexagonImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setup();
    }

    public HexagonImageView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setup();
    }

    private void setup() {
        paint = new Paint();
        paint.setAntiAlias(true);

        paintBorder = new Paint();
        setBorderColor(Color.WHITE);
        paintBorder.setAntiAlias(true);
        paintBorder.setStrokeCap(Paint.Cap.ROUND);
        paint.setStrokeCap(Paint.Cap.ROUND);
        paintBorder.setStrokeCap(Paint.Cap.SQUARE);
        paint.setStrokeCap(Paint.Cap.SQUARE);
        paint.setStyle(Paint.Style.FILL);
        paintBorder.setStyle(Paint.Style.FILL);

        this.setLayerType(LAYER_TYPE_SOFTWARE, paintBorder);

        hexagonPath = new Path();
        hexagonBorderPath = new Path();
    }

    public void setRadius(float r) {
        this.radius = r;
        calculatePath();
    }

    public void setBorderWidth(int borderWidth)  {
        this.mBorderWidth = borderWidth;
        this.invalidate();
    }
    public void setCornerRadius(int cornerRadius) {
        mCornerRadius=cornerRadius;
        PathEffect pathEffect = new CornerPathEffect(cornerRadius);
        paintBorder.setPathEffect(pathEffect);
        paint.setPathEffect(pathEffect);

    }
    public void setBorderColor(int borderColor)  {
        if (paintBorder != null)
            paintBorder.setColor(borderColor);

        this.invalidate();
    }

    private void calculatePath() {

        float centerX = viewWidth/2;
        float centerY = viewHeight/2;

        hexagonBorderPath.moveTo(centerX, centerY - radius);
        hexagonBorderPath.lineTo((float) (centerX + Math.sqrt(3f)*radius/2), centerY - radius/2);
        hexagonBorderPath.lineTo((float) (centerX + Math.sqrt(3f)*radius/2), centerY + radius/2);
        hexagonBorderPath.lineTo(centerX, centerY + radius);
        hexagonBorderPath.lineTo((float) (centerX - Math.sqrt(3f)*radius/2), centerY + radius/2);
        hexagonBorderPath.lineTo((float) (centerX - Math.sqrt(3f)*radius/2), centerY - radius/2);
        hexagonBorderPath.close();


        float radiusBorder = radius - mBorderWidth;


        hexagonPath.moveTo(centerX, centerY - radiusBorder);
        hexagonPath.lineTo((float) (centerX + Math.sqrt(3f)*radiusBorder/2), centerY - radiusBorder/2);
        hexagonPath.lineTo((float) (centerX + Math.sqrt(3f)*radiusBorder/2), centerY + radiusBorder/2);
        hexagonPath.lineTo(centerX, centerY + radiusBorder);
        hexagonPath.lineTo((float) (centerX - Math.sqrt(3f)*radiusBorder/2), centerY + radiusBorder/2);
        hexagonPath.lineTo((float) (centerX - Math.sqrt(3f)*radiusBorder/2), centerY - radiusBorder/2);
        hexagonPath.close();
        invalidate();
    }


    private void loadBitmap()  {
        BitmapDrawable bitmapDrawable = (BitmapDrawable) this.getDrawable();

        if (bitmapDrawable != null){
            image = bitmapDrawable.getBitmap();
        }

    }

    @SuppressLint("DrawAllocation")
    @Override
    public void onDraw(Canvas canvas){
        super.onDraw(canvas);

        loadBitmap();

        // init shader
        if (image != null) {

            canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR);
            shader = new BitmapShader(Bitmap.createScaledBitmap(image, canvas.getWidth(), canvas.getHeight(), false), Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
            paint.setShader(shader);
            canvas.drawPath(hexagonBorderPath, paintBorder);
            canvas.drawPath(hexagonPath, paint);
            canvas.clipPath(hexagonPath, Region.Op.DIFFERENCE);


        }

    }

    @Override
    public void onMeasure(int widthMeasureSpec, int heightMeasureSpec){
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        int width = measureWidth(widthMeasureSpec);
        int height = measureHeight(heightMeasureSpec, widthMeasureSpec);

        viewWidth = width - (mBorderWidth * 2);
        viewHeight = height - (mBorderWidth * 2);

        radius = height / 2 - mBorderWidth;

        calculatePath();

        setMeasuredDimension(width, height);
    }

    private int measureWidth(int measureSpec)   {
        int result = 0;
        int specMode = MeasureSpec.getMode(measureSpec);
        int specSize = MeasureSpec.getSize(measureSpec);

        if (specMode == MeasureSpec.EXACTLY)  {
            result = specSize;
        }
        else {
            result = viewWidth;
        }

        return result;
    }

    private int measureHeight(int measureSpecHeight, int measureSpecWidth)  {
        int result = 0;
        int specMode = MeasureSpec.getMode(measureSpecHeight);
        int specSize = MeasureSpec.getSize(measureSpecHeight);

        if (specMode == MeasureSpec.EXACTLY) {
            result = specSize;
        }
        else {
            result = viewHeight;
        }

        return (result + 2);
    }

}