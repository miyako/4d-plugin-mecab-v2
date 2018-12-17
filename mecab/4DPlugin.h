/* --------------------------------------------------------------------------------
 #
 #	4DPlugin.h
 #	source generated by 4D Plugin Wizard
 #	Project : MeCab
 #	author : miyako
 #	2018/12/11
 #
 # --------------------------------------------------------------------------------*/

#include <mutex>
#include <iostream>
#include <map>
#include <set>
#include <vector>
#include <string>
#include <fstream>
#include "char_property.h"
#include "connector.h"
#include "dictionary.h"
#include "dictionary_rewriter.h"
#include "feature_index.h"
#include "mecab.h"
#include "param.h"
#include "context_id.h"
#include "writer.h"

#include "json/json.h"

#include "iconv.h"
#include "iconv_utils.h"

// --- MeCab
void MeCab_SET_MODEL(sLONG_PTR *pResult, PackagePtr pParams);
void MeCab_Get_model(sLONG_PTR *pResult, PackagePtr pParams);
void _MeCab(sLONG_PTR *pResult, PackagePtr pParams);

// --- MeCab Dictionary
void MeCab_INDEX_DICTIONARY(sLONG_PTR *pResult, PackagePtr pParams);
void MeCab_GENERATE_DICTIONARY(sLONG_PTR *pResult, PackagePtr pParams);

void OnStartup();
void OnExit();

void GetResourceDir(std::string &resourcedir);
void GetRcFile(std::string &rcfile);
void GetDictDir(std::string& dicdir, std::string& dictName);

typedef struct
{
    C_TEXT *callback_method;
    int progress;
}progress_ctx_t;

typedef enum
{
    callback_event_open_file = 1,
    callback_event_create_file = 2,
    callback_event_emit_double_array = 3,
    callback_event_emit_matrix = 4,
    callback_event_error_missing_file = -1,
    callback_event_error_missing_csv_files = -2,
    callback_event_error_invalid_model_file = -3,
    callback_event_error_invalid_csv_file = -4,
    callback_event_error_open_file = -5,
    callback_event_error_create_file = -6,
    callback_event_error_invalid_def_file = -7,
    callback_event_error_invalid_rc_file = -8,
    callback_event_error_write_file = -9
    
}callback_event_t;

BOOL callback(C_TEXT *Param2_callback,
              callback_event_t event_t,
              std::string& message,
              size_t current,
              size_t total);

#define DIC_VERSION 102

#define STDERR_DEBUG_INFO 1
#define STDERR_DEBUG_FEATURE 0
#define STDERR_DEBUG_WORD 0