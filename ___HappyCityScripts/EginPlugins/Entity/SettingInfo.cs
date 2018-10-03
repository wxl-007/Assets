using UnityEngine;
using System.Collections;

public class SettingInfo {

	private static SettingInfo _instance;
	public static SettingInfo Instance {
		get {
			if(_instance == null) {
				_instance = new SettingInfo();
				_instance.LoadInfo();
			}
			return _instance;
		}
	}
	
	public float bgVolume;
	public float effectVolume;
	public bool specialEfficacy;
	public bool autoNext;
    public bool gameVoice;
	public bool deposit;//托管
    public bool chipmin;//最小下注
	public int keynoteColor;
	public int keynoteTexture;

	public bool YSZ_autoVS;
	
	public void LoadInfo () {
		bgVolume = PlayerPrefs.GetFloat("SettingBgVolume", 0.6f);
		effectVolume = PlayerPrefs.GetFloat("SettingEffectVolume", 0.6f);
		specialEfficacy = (PlayerPrefs.GetInt("SettingSpecialEfficacy", 1) == 1);
		autoNext = (PlayerPrefs.GetInt("SettingAutoNext", 1) == 1);
		deposit = (PlayerPrefs.GetInt("SettingDeposit", 0) == 1);
        chipmin = (PlayerPrefs.GetInt("SettingChipmin", 1) == 1);

		keynoteColor = PlayerPrefs.GetInt("SettingKeynoteColor", 0);
		keynoteTexture = PlayerPrefs.GetInt("SettingKeynoteTexture", 0);

		YSZ_autoVS = (PlayerPrefs.GetInt("SettingYSZ_autoVS", 1) == 1);
	}
	
	public void SaveInfo () {
		PlayerPrefs.SetFloat("SettingBgVolume", bgVolume);
		PlayerPrefs.SetFloat("SettingEffectVolume", effectVolume);
		PlayerPrefs.SetInt("SettingSpecialEfficacy", specialEfficacy?1:0);
		PlayerPrefs.SetInt("SettingAutoNext", autoNext?1:0);
		PlayerPrefs.SetInt("SettingKeynoteColor", keynoteColor);
		PlayerPrefs.SetInt("SettingKeynoteTexture", keynoteTexture);
		PlayerPrefs.SetInt("SettingDeposit", deposit?1:0);
        PlayerPrefs.SetInt("SettingChipmin", chipmin?1:0);

		PlayerPrefs.SetInt("SettingYSZ_autoVS", YSZ_autoVS?1:0);

		PlayerPrefs.Save();
	}
}
