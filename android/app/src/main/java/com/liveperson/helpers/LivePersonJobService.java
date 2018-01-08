package com.liveperson.helpers;

/**
 * Created by dvillacis on 1/3/18.
 */

// Required Firebase Job Imports

import android.util.Log;

import com.firebase.jobdispatcher.JobParameters;
import com.firebase.jobdispatcher.JobService;

// Import Log

public class LivePersonJobService extends JobService {

  private static final String TAG = "LivePersonJobService";

  @Override
  public boolean onStartJob(JobParameters jobParameters) {
    Log.d(TAG, "Performing long running task in scheduled job");
    // TODO(developer): add long running task here.
    return false;
  }

  @Override
  public boolean onStopJob(JobParameters jobParameters) {
    return false;
  }

}