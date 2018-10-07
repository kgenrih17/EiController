package com.evogence.eilink.common

import android.content.Context
import android.content.pm.PackageManager
import android.os.Environment
import android.os.StatFs
import java.util.*

/**
 * Created by Anatolij on 10/10/17.
 */
class SysInfo(val context: Context): ISysInfo
{
    override val cpuUsage: Double
        get() = 0.0
    override val shortVersion: String
        get() = try
        {
            val pInfo = context.packageManager.getPackageInfo(context.packageName, 0)
            pInfo.versionName
        }
        catch(ex: PackageManager.NameNotFoundException)
        {
            ex.printStackTrace()
            "N/A"
        }

    override val uptime: Long
        get() = 0
    override val connectionType: EConnectionType
        get() = EConnectionType.NONE
    override val currentTimestamp: Long
        get() = Calendar.getInstance().timeInMillis / 1000L
    override val udid: String
        get() = SystemInformation.getUdid(context)
    override val appVersion: String
        get() = ""
    override val platform: String
        get() = ""
    override val timeZone: String
        get() = ""
    override val ip: String
        get() = ""
    override val systemOS: String
        get() = ""
    override val macAddress: String
        get() = ""
    override val deviceModel: String
        get() = ""
    override val memoryInfo: MemoryInfo
        get()
        {
            val result = MemoryInfo()

            try
            {
                val info = Runtime.getRuntime()
                result.freeRAM = info.freeMemory() / 1024L
                result.totalRAM = info.totalMemory() / 1024L
            }
            catch(e: Exception)
            {
                e.printStackTrace()
            }

            result.totalFlash = getTotalExternalMemorySize()
            result.availableFlash = getAvailableExternalMemorySize()
            result.reservedFlash = 0

            return result
        }


    override fun getFormattedDate(format: String): String
    {
        return ""
    }

    fun getAvailableExternalMemorySize(): Long
    {
        val path = Environment.getExternalStorageDirectory()
        return getAvailableSizeByPath(path.absolutePath)
    }

    fun getAvailableSizeByPath(path: String?): Long
    {
        var size: Long = -1

        if(path != null && !path.isEmpty())
        {
            val stat = StatFs(path)
            val blockSize = stat.blockSize.toLong()
            val availableBlocks = stat.availableBlocks.toLong()
            size = blockSize * availableBlocks
        }

        return size
    }

    fun getTotalExternalMemorySize(): Long
    {
        val path = Environment.getExternalStorageDirectory()
        return getSizeByPath(path.absolutePath)
    }

    fun getSizeByPath(path: String?): Long
    {
        var size: Long = -1

        if(path != null && !path.isEmpty())
        {
            val stat = StatFs(path)
            val blockSize = stat.blockSize.toLong()
            val blockCount = stat.blockCount.toLong()
            size = blockSize * blockCount
        }

        return size
    }
}
