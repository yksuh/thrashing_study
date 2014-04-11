/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
* Matthew Johnson 
* Rui Zhang (http://www.cs.arizona.edu/people/ruizhang/)
*/
package azdblab.model.experiment;

import javax.crypto.*;

import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.KeySpec;
import java.io.*;

public class Decryptor {

	private Cipher decipher;
	
	private byte[] salt = {
            (byte)0xA9, (byte)0x9B, (byte)0xC8, (byte)0x32,
            (byte)0x56, (byte)0x35, (byte)0xE3, (byte)0x03
        };
    
    //Iteration count
    private int iterationCount = 19;
    
    public Decryptor(String pass) {
        
    	try {
	    		
	    	KeySpec keySpec = new PBEKeySpec(pass.toCharArray(), salt, iterationCount);
	        SecretKey key = SecretKeyFactory.getInstance(
	            "PBEWithMD5AndDES").generateSecret(keySpec);
	        decipher = Cipher.getInstance(key.getAlgorithm());
	
	        // Prepare the parameter to the ciphers
	        AlgorithmParameterSpec paramSpec = new PBEParameterSpec(salt, iterationCount);
	
	        // Create the ciphers
	        decipher.init(Cipher.DECRYPT_MODE, key, paramSpec);
	        
	    } catch (java.security.InvalidAlgorithmParameterException e) {
	    } catch (java.security.spec.InvalidKeySpecException e) {
	    } catch (javax.crypto.NoSuchPaddingException e) {
	    } catch (java.security.NoSuchAlgorithmException e) {
	    } catch (java.security.InvalidKeyException e) {
	    }
    }

    
    public String decrypt(String str) {
        try {
            // Decode base64 to get bytes
            byte[] dec = new sun.misc.BASE64Decoder().decodeBuffer(str);

            // Decrypt
            byte[] utf8 = decipher.doFinal(dec);

            // Decode using utf-8
            return new String(utf8, "UTF8");
            
        } catch (javax.crypto.BadPaddingException e) {
        	e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
        	e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
        	e.printStackTrace();
        } catch (IOException e) {
        	e.printStackTrace();
        }
        return null;
    }

}
