//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2015 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Very simple sprite animation. Attach to a sprite and specify a common prefix such as "idle" and it will cycle through them.
/// </summary>

[ExecuteInEditMode]
[RequireComponent(typeof(UISprite))]
[AddComponentMenu("NGUI/UI/Sprite Animation")]
public class UISpriteAnimation : MonoBehaviour
{
	[HideInInspector][SerializeField] protected int mFPS = 30;
	[HideInInspector][SerializeField] protected string mPrefix = "";
	[HideInInspector][SerializeField] protected bool mLoop = true;
	[HideInInspector][SerializeField] protected bool mSnap = true;

	protected UISprite mSprite;
	protected float mDelta = 0f;
	protected int mIndex = 0;
	protected bool mActive = true;
	protected List<string> mSpriteNames = new List<string>();
    protected System.Action mOnComplete;

	//2016.3.15
	private int mCount=0;
	private int mMax = 1;

	//2016.5.30
	protected bool _isInvert = false;
	public bool isInvert{get;set;}

	/// <summary>
	/// Number of frames in the animation.
	/// </summary>

	public int frames { get { return mSpriteNames.Count; } }

	/// <summary>
	/// Animation framerate.
	/// </summary>

	public int framesPerSecond { get { return mFPS; } set { mFPS = value; } }

	/// <summary>
	/// Set the name prefix used to filter sprites from the atlas.
	/// </summary>

	public string namePrefix { get { return mPrefix; } set { if (mPrefix != value) { mPrefix = value; RebuildSpriteList(); } } }

	/// <summary>
	/// Set the animation to be looping or not
	/// </summary>

	public bool loop { get { return mLoop; } set { mLoop = value; } }

	/// <summary>
	/// Returns is the animation is still playing or not
	/// </summary>

	public bool isPlaying { get { return mActive; } }

	/// <summary>
	/// Rebuild the sprite list first thing.
	/// </summary>

	protected virtual void Start () { RebuildSpriteList(); }

	/// <summary>
	/// Advance the sprite animation process.
	/// </summary>

	protected virtual void Update ()
	{
		if (mActive && mSpriteNames.Count > 1 && Application.isPlaying && mFPS > 0)
		{
			mDelta += RealTime.deltaTime;
			float rate = 1f / mFPS;

			if (rate < mDelta)
			{
				mDelta = (rate > 0f) ? mDelta - rate : 0f;

				if(isInvert){
					//add at 2016.5.30
					if (--mIndex <= 0)
					{
						mActive = mLoop;
						mCount++;
						if(!loop){
							if(mCount>=mMax){
								mCount = 0;
								mActive = false;
								if(mOnComplete != null){
									mOnComplete();
								}
							}else{
								mActive = true;
							}
						}
						mIndex = mSpriteNames.Count-1;
					}else{
						if(mIndex>= mSpriteNames.Count){
							mIndex = mSpriteNames.Count-1;
						}
					}
				}else{
					if (++mIndex >= mSpriteNames.Count)
					{
						mIndex = 0;
						mActive = mLoop;
						mCount++;
						//add by xiaoyong 2016.1.21  
						//Animation callback function feature
						if(!loop){
							//modified 2016.3.15
							if(mCount>=mMax){
								mCount = 0;
								mActive = false;
								if(mOnComplete != null){
									mOnComplete();
								}
							}else{
								mActive = true;
							}
						}
					}
				}

                if (mActive)
				{
					mSprite.spriteName = mSpriteNames[mIndex];
					if (mSnap) mSprite.MakePixelPerfect();
				}
			}
		}
	}

	/// <summary>
	/// Rebuild the sprite list after changing the sprite name.
	/// </summary>

	public void RebuildSpriteList ()
	{
		if (mSprite == null) mSprite = GetComponent<UISprite>();
		mSpriteNames.Clear();

		if (mSprite != null && mSprite.atlas != null)
		{
			List<UISpriteData> sprites = mSprite.atlas.spriteList;

			for (int i = 0, imax = sprites.Count; i < imax; ++i)
			{
				UISpriteData sprite = sprites[i];

				if (string.IsNullOrEmpty(mPrefix) || sprite.name.StartsWith(mPrefix))
				{
					mSpriteNames.Add(sprite.name);
				}
			}
			mSpriteNames.Sort();
		}
	}
	
	/// <summary>
	/// Reset the animation to the beginning.
	/// </summary>

	public void Play () { isInvert=false; mActive = true; }

	/// <summary>
	/// Pause the animation.
	/// </summary>

	public void Pause () { mActive = false; }

	/// <summary>
	/// Reset the animation to frame 0 and activate it.
	/// </summary>

	public void ResetToBeginning ()
	{
		//2015.3.15
		mCount = 0;
		mMax = 1;

		mActive = true;
		if(isInvert){
			mIndex = mSpriteNames.Count-1;
		}else{
			mIndex = 0;
		}

		if (mSprite != null && mSpriteNames.Count > 0)
		{
			mSprite.spriteName = mSpriteNames[mIndex];
			if (mSnap) mSprite.MakePixelPerfect();
		}
	}

	//add at 2016.5.30
	public void invertPlay(System.Action callback = null)
	{
		isInvert = true;
		mOnComplete = callback;
		ResetToBeginning();
	}

    //add by xiaoyong 2016.1.21  
    //Animation callback function feature
    public void playWithCallback(System.Action callback = null)
    {
		isInvert = false;
        mOnComplete = callback;
        ResetToBeginning();
    }

	//2015.3.15
	public void playWithCallback(int playCount, System.Action callback = null)
	{
		isInvert = false;
		mOnComplete = callback;
		ResetToBeginning();
		mMax = playCount;
	}
}
