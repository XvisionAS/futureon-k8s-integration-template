<script>
  /**
   * DocumentList component displays a list of documents with their basic information
   * 
   * @component
   */

  /**
   * Array of documents to display
   * @type {Array<Object>}
   */
  const { documents = [] } = $props();

  /**
   * Formats a date string into a more readable format
   *
   * @param {string} dateString - ISO date string to format
   * @returns {string} Formatted date string
   */
  function formatDate(dateString) {
    if (!dateString) return 'Unknown date';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  /**
   * Extracts the document name from vendor attributes or falls back to the file name
   *
   * @param {Object} document - The document object
   * @returns {string} The document name
   */
  function getDocumentName(document) {
    return document.vendorAttributes?.name || document.fileName || 'Unnamed document';
  }
</script>

<div class="document-list-container">
  <h3 class="mb-4">Documents</h3>
  
  {#if documents.length === 0}
    <div class="alert alert-info" role="alert">
      No documents available.
    </div>
  {:else}
    <div class="table-responsive">
      <table class="table table-striped table-hover">
        <thead class="table-dark">
          <tr>
            <th>Name</th>
            <th>Created</th>
            <th>Creator</th>
          </tr>
        </thead>
        <tbody>
          {#each documents as document (document.id)}
            <tr class="table-dark">
              <td>{getDocumentName(document)}</td>
              <td>{formatDate(document.created)}</td>
              <td>{document.creator}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  {/if}
</div>

<style>
  .document-list-container {
    margin: 1rem 0;
  }
  
  .table {
    font-size: 0.9rem;
  }
</style>