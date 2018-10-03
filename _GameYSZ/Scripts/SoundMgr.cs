using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SoundMgr : MonoBehaviour {

	public UISlider bgmSlider;

	public AudioClip bgm;
	public AudioSource player;
	// Use this for initialization

	public AudioClip[] randomGroup;

	public AudioClip[] clipAry1;
	public AudioClip[] clipAry2;
	public AudioClip[] clipAry3;

	public AudioClip clipDeal;
	public AudioClip clipBet;
	public AudioClip clipWin;
	public AudioClip clipLose;
	public AudioClip clipVs;
//	public Dictionary<string, AudioClip> dc;

	public static SoundMgr instance;

	private List<AudioSource> players;
	void Awake(){
		instance = this;
	}
	void Start () {
		players = new List<AudioSource>();
		init();
		initPlayerPool();
		playBgm();
	}

	void OnDestroy(){
		instance = null;
	}

	protected virtual void init(){

	}

	protected virtual void initPlayerPool()
	{
		for(int i=0; i< 4; i++){
			GameObject obj = new GameObject();
			obj.name = "AudioSource"+ i;
			players.Add( obj.AddComponent<AudioSource>() );
			obj.transform.parent = this.transform;
		}
	}

	public virtual void playBgm()
	{
		if(player == null){
			player = this.gameObject.AddComponent<AudioSource>();
		}
		player.clip = bgm;
		player.loop = true;
		player.volume = SettingInfo.Instance.bgVolume;

		player.Play();
		Debug.Log(bgm);
		Debug.LogError("playBgm!!!!"+ SettingInfo.Instance.bgVolume);
	}

	public void sliderChanged()
	{
		SettingInfo.Instance.bgVolume = bgmSlider.value;
		if(player != null){
			player.volume = SettingInfo.Instance.bgVolume;
		}
	}

	public void playRandEft()
	{
		int len = randomGroup.Length;
		int randValue = Random.Range(0, len);
		AudioClip clip = randomGroup[randValue];
		playEft(clip);
	}

	public void playEft(AudioClip clip, ulong delay = 0)
	{
		if(clip == null)return;
		AudioSource eftPlayer = getFreeAudioS();
		eftPlayer.clip = clip;
		eftPlayer.loop = false;
		eftPlayer.volume = SettingInfo.Instance.bgVolume;
		if(delay > 0){
			eftPlayer.PlayDelayed(delay);
		}else{
			eftPlayer.Play();
		}
//		eftPlayer.PlayOneShot(clip);
	}
	public virtual void playEft(string clipPath)
	{
		AudioClip clip = Resources.Load<AudioClip>(clipPath);
		playEft(clip);
	}

	public void playRes1(int index){
		playEft( clipAry1[index] );
	}

	public void talkAddJetton(int isFemale=0){
		if(isFemale == 0){
			playEft( clipAry1[0]);
		}else{
			playEft( clipAry1[1]);
		}

	}
	public void talkFollowJetton(int isFemale=0){
		if(isFemale == 0){
			playEft( clipAry1[2]);
		}else{
			playEft( clipAry1[3]);
		}
	}
	public void talkGiveup(int isFemale=0){
		if(isFemale == 0){
			playEft( clipAry1[4]);
		}else{
			playEft( clipAry1[5]);
		}
	}
	public void talkSeeCard(int isFemale=0){
		if(isFemale == 0){
			playEft( clipAry1[6]);
		}else{
			playEft( clipAry1[7]);
		}
	}
	public void talkVS(int isFemale=0){
		if(isFemale == 0){
			playEft( clipAry1[8]);
		}else{
			playEft( clipAry1[9]);
		}
	}

	public void gameWin()
	{
		playEft(clipWin);
	}
	public void gameLose()
	{
		playEft(clipLose);
	}

	private AudioSource getFreeAudioS()
	{
		AudioSource audioPlayer = null;
		for(int i=0; i< players.Count; i++){
			if(!players[i].isPlaying ){
				audioPlayer = players[i];
			}
		}
		if(audioPlayer == null){
			GameObject obj = new GameObject();

			audioPlayer = obj.AddComponent<AudioSource>();
			players.Add( audioPlayer );
			obj.name = "AudioSource"+ players.Count;
			obj.transform.parent = this.transform;
		}
		return audioPlayer;
	}

	//DDZsoundMgr need
	public virtual void drawCard(int cardType , bool isFemale, int pokerNum ){

	}
	public virtual void chat(int id){}
	public virtual void playRandEftDc(string key, bool isFemale){}
	public virtual void changeBGM(bool is131){}
}
