package azdblab.plugins;

import azdblab.Constants;
import azdblab.executable.Main;

public abstract class Plugin {

	public Plugin() {
		try {
			if (!checkIfSupported(getSupportedShelfs())) {
				Main._logger.reportError("Error plugin version "
						+ getSupportedShelfs()
						+ " is not supported on AZDBLab "
						+ Constants.AZDBLAB_VERSION + " \n on plugin "
						+ this.getClass().getName());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * true if its supported
	 * 
	 * @param pluginVersion
	 * @return
	 */
	private boolean checkIfSupported(String pluginVersion) {
		String tmpVersion = Constants.AZDBLAB_VERSION.replace(".", "TOKEN");
		String majorVersion = tmpVersion.split("TOKEN")[0].trim();
		String minorVersion = tmpVersion.split("TOKEN")[1].trim();

		String tmpPluginVersion = pluginVersion.replace(".", "TOKEN");
		String pluginMajorVersion = tmpPluginVersion.split("TOKEN")[0].trim();
		String pluginMinorVersion = tmpPluginVersion.split("TOKEN")[1].trim();

		if (pluginMajorVersion.equals("X")) {
			return true;
		}

		if (!pluginMajorVersion.equals(majorVersion)) {
			return false;
		}

		if (pluginMinorVersion.equals("X")) {
			return true;
		}

		if (!pluginMinorVersion.equals(minorVersion)) {
			return false;
		}
		return true;

	}

	/**
	 * Semantics on what it returns 5.3 = supported on only 5.3 5.X = supported
	 * on all of azdblab 5 X.X = supported on everything
	 * 
	 * @return
	 */
	public abstract String getSupportedShelfs();

	public static String getVersion() {
		return "1.0";
	}


}
