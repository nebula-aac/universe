/*
 * This file was automatically generated.
 * DO NOT MODIFY BY HAND.
 * Run `yarn special-lint-fix` to update
 */

/**
 * Modules that should be provided as shared modules to the share scope. When provided, property name is used to match modules, otherwise this is automatically inferred from share key.
 */
export type Provides = (ProvidesItem | ProvidesObject)[] | ProvidesObject;
/**
 * Request to a module that should be provided as shared module to the share scope (will be resolved when relative).
 */
export type ProvidesItem = string;

export interface ProvideSharedPluginOptions {
  /**
   * Modules that should be provided as shared modules to the share scope. When provided, property name is used to match modules, otherwise this is automatically inferred from share key.
   */
  provides: Provides;
  /**
   * Share scope name used for all provided modules (defaults to 'default').
   */
  shareScope?: string | string[];
}
/**
 * Modules that should be provided as shared modules to the share scope. Property names are used as share keys.
 */
export interface ProvidesObject {
  /**
   * Modules that should be provided as shared modules to the share scope.
   */
  [k: string]: ProvidesConfig | ProvidesItem;
}
/**
 * Advanced configuration for modules that should be provided as shared modules to the share scope.
 */
export interface ProvidesConfig {
  /**
   * Include the provided module directly instead behind an async request. This allows to use this shared module in initial load too. All possible shared modules need to be eager too.
   */
  eager?: boolean;
  /**
   * Key in the share scope under which the shared modules should be stored.
   */
  shareKey?: string;
  /**
   * Share scope name.
   */
  shareScope?: string | string[];
  /**
   * Version of the provided module. Will replace lower matching versions, but not higher.
   */
  version?: false | string;
  /**
   * Version requirement from module in share scope.
   */
  requiredVersion?: false | string;
  /**
   * Allow only a single version of the shared module in share scope (disabled by default).
   */
  singleton?: boolean;
  /**
   * Do not accept shared module if version is not valid (defaults to yes, if local fallback module is available and shared module is not a singleton, otherwise no, has no effect if there is no required version specified).
   */
  strictVersion?: boolean;
  /**
   * Layer for the shared module.
   */
  layer?: string;
  /**
   * The actual request to use for importing the module. If not specified, the property name/key will be used.
   */
  request?: string;
  /**
   * Include filters for providing shared modules.
   */
  include?: {
    /**
     * Version requirement that must be satisfied for the module to be provided.
     */
    version?: string;
    /**
     * Request pattern that must match for the module to be provided.
     */
    request?: string | RegExp;
  };
  /**
   * Exclude filters for providing shared modules.
   */
  exclude?: {
    /**
     * Version requirement that if satisfied will exclude the module from being provided.
     */
    version?: string;
    /**
     * Request pattern that if matched will exclude the module from being provided.
     */
    request?: string | RegExp;
  };
}
